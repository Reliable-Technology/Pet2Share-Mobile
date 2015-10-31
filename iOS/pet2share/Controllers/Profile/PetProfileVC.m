//
//  PetProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/10/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PetProfileVC.h"
#import "WSConstants.h"
#import "AppColor.h"
#import "Constants.h"
#import "Pet2ShareService.h"
#import "PostImageCollectionCell.h"
#import "PostTextCollectionCell.h"
#import "LoadingCollectionCell.h"
#import "AddEditPetProfileVC.h"
#import "NewPostVC.h"
#import "CommentVC.h"

static CGFloat kCellSpacing                             = 5.0f;
static NSString * const kPostTextCellIdentifier         = @"posttextcollectioncell";
static NSString * const kPostTextCellNibName            = @"PostTextCollectionCell";
static NSString * const kPostImageCellIdentifier        = @"postimagecollectioncell";
static NSString * const kPostImageCellNibName           = @"PostImageCollectionCell";
static NSString * const kLoadingCellIdentifier          = @"loadingcollectioncell";
static NSString * const kLoadingCellNibName             = @"LoadingCollectionCell";

@interface PetProfileVC () <Pet2ShareServiceCallback, NewPostDelegate>
{
    NSInteger _pageNumber;
    BOOL _hasAllData;
    BOOL _isRequesting;
}

@property (nonatomic, strong) TransitionZoom *transitionZoom;

@end

@implementation PetProfileVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kPostTextCellIdentifier;
        self.customNibName = kPostTextCellNibName;
        _transitionZoom = [TransitionZoom new];
        _pageNumber = 0;
        _hasAllData = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    // Custom Back button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight)];
    [backButton setImage:[Graphics tintImage:[UIImage imageNamed:@"icon-arrowback"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // Custom Post button
    UIButton *postButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight)];
    [postButton setImage:[Graphics tintImage:[UIImage imageNamed:@"icon-compose"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(composeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    
    // Extra cell
    [self.collectionView registerNib:[UINib nibWithNibName:kPostImageCellNibName bundle:nil]
          forCellWithReuseIdentifier:kPostImageCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:kLoadingCellNibName bundle:nil]
          forCellWithReuseIdentifier:kLoadingCellIdentifier];
    
    // Empty Data View
    self.emptyDataView = [[EmptyDataView alloc] initWithFrame:CGRectMake(0, 0, [EmptyDataView width], [EmptyDataView height])];
    [self.emptyDataView updateViewWithFirstText:NSLocalizedString(@"PET HAVE NO POST YET!", @"")
                                     secondText:NSLocalizedString(@"to add new post", @"")
                                  iconImageName:@"img-compose"];
    self.emptyDataView.center = CGPointMake(self.collectionView.frame.size.width/2,
                                            self.collectionView.frame.size.height/2 - 49);  // Offset the TabBar
    [self.collectionView addSubview:self.emptyDataView];
    [self.collectionView bringSubviewToFront:self.emptyDataView];
    
    // Request Data
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueAddEditPetProfile])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddEditPetProfileVC *addEditProfileVC = (AddEditPetProfileVC *)navController.topViewController;
        if (addEditProfileVC)
        {
            addEditProfileVC.petProfileMode = EditPetProfile;
            addEditProfileVC.pet = self.pet;
        }
        navController.transitioningDelegate = self.transitionManager;
    }
    else if ([segue.identifier isEqualToString:kSegueNewPost])
    {
        NewPostVC *newPostVC = (NewPostVC *)segue.destinationViewController;
        newPostVC.delegate = self;
        newPostVC.transitioningDelegate = self.transitionZoom;
        newPostVC.pet = self.pet;
    }
    else if ([segue.identifier isEqualToString:kSegueComment])
    {
        UINavigationController *navController = segue.destinationViewController;
        navController.transitioningDelegate = self.transitionZoom;
        CommentVC *commentVC = (CommentVC *)navController.topViewController;
        if (commentVC) commentVC.post = (Post *)sender;
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark - Protected Instance Methods

- (NSString *)getProfileImageUrl
{
    return self.pet.profilePictureUrl;
}

- (NSString *)getProfileCoverImageUrl
{
    return self.pet.coverPictureUrl;
}

- (UIImage *)getSessionImage
{
    return [[AppData sharedInstance] getObject:kPetSessionAvatarImage];
}

-  (NSString *)getProfileName
{
    return self.pet.name;
}

- (NSString *)getEditSegueIdentifier
{
    return kSegueAddEditPetProfile;
}

- (UIImage *)getProfileSessionAvatarImage
{
    return [[Pet2ShareUser current] getPetSessionAvatarImage:self.pet.identifier];
}

#pragma mark - Events

- (void)backBarButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)composeButtonTapped
{
    [self performSegueWithIdentifier:kSegueNewPost sender:self];
}

- (void)didPost
{
    _pageNumber = 0;
    _hasAllData = NO;
    [self requestData];
}

#pragma mark - Web Services

- (void)requestData
{
    [self.emptyDataView hide];
    
    if (_isRequesting) return;
    _isRequesting = YES;
    
    Pet2ShareService *service = [Pet2ShareService new];
    _pageNumber++;
    fTRACE(@"Page Number: %ld", (long)_pageNumber);
    [service getPostsByPet:self petId:self.pet.identifier postCount:kNumberOfPostPerPage pageNumber:_pageNumber];
}

- (void)onReceiveSuccess:(NSArray *)objects
{
    _isRequesting = NO;
    fTRACE(@"Number of Objects: %ld", (long)objects.count);
    if (_pageNumber == 1)
    {
        [self.items removeAllObjects];
    }
    if (objects.count == 0 || objects.count < kNumberOfPostPerPage)
    {
        _hasAllData = YES;
    }
    
    [self.items addObjectsFromArray:objects];
    [self.collectionView reloadData];
    
    if ([self.items count] == 0)
    {
        [self.emptyDataView show];
    }
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    _isRequesting = NO;
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

#pragma mark - Collection View

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]])
    {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell height]);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell height]-10.0f);
        [layout setupLayout:OneColumn cellHeight:[PostTextCollectionCell defaultHeight] spacing:kCellSpacing];
        layout.parallaxHeaderAlwaysOnTop = NO;
        layout.disableStickyHeaders = NO;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [CollectionViewLayout getItemWidth:self.collectionView.frame.size.width layoutType:OneColumn spacing:kCellSpacing];
    if (indexPath.row < self.items.count)
    {
        Post *post = [self.items objectAtIndexedSubscript:indexPath.row];
        CGSize cellSize;
        if ([Utils isNullOrEmpty:post.postUrl])
            cellSize = CGSizeMake(itemWidth, [PostTextCollectionCell heightByText:post.postDescription itemWidth:itemWidth]);
        else
            cellSize = CGSizeMake(itemWidth, [PostImageCollectionCell heightByText:post.postDescription itemWidth:itemWidth]);
        return cellSize;
    }
    else
    {
        return CGSizeMake(itemWidth, [LoadingCollectionCell height]);
    }
}


- (void)didScrollOutOfBound
{
//    [self requestData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfCells;
    
    if (self.items.count == 0)
    {
        if (_hasAllData) numberOfCells = 0;
        else numberOfCells = 1;
    }
    else
    {
        if (_hasAllData) numberOfCells = self.items.count;
        else numberOfCells = self.items.count+1;
    }
    
    // fTRACE("Number of Cells: %ld", (long)numberOfCells);
    
    return numberOfCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    @try
    {
        // fTRACE("Index: %ld", indexPath.row);
        
        if (indexPath.row < self.items.count)
        {
            Post *post = [self.items objectAtIndex:indexPath.row];
            NSString *postDate = [Utils formatNSDateToString:post.dateAdded
                                                  withFormat:kFormatDayOfWeekWithDateTime];
            
            NSString *profileImageUrl = kEmptyString;
            NSString *profileName = kEmptyString;
            UIImage *profileSessionImage = nil;
            
            if (post.isPostByPet)
            {
                profileImageUrl = post.pet.profilePictureUrl;
                profileName = post.pet.name;
            }
            else
            {
                profileImageUrl = post.user.profilePictureUrl;
                profileName = post.user.name;
                if (post.user.identifier == [Pet2ShareUser current].identifier)
                    profileSessionImage = [Pet2ShareUser current].getUserSessionAvatarImage;
            }
            
            if ([Utils isNullOrEmpty:post.postUrl])
            {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
                [(PostTextCollectionCell *)cell loadDataWithImageUrl:profileImageUrl
                                                placeHolderImageName:@"img-avatar"
                                                        sessionImage:profileSessionImage
                                                            delegate:self
                                                              postId:post.identifier
                                                          isPostById:post.postedBy
                                                         isPostByPet:post.isPostByPet
                                                         primaryText:profileName
                                                       secondaryText:postDate
                                                     descriptionText:post.postDescription
                                                          statusText:post.getPostStatusString];
            }
            else
            {
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPostImageCellIdentifier forIndexPath:indexPath];
                [(PostImageCollectionCell *)cell loadDataWithImageUrl:profileImageUrl
                                                 placeHolderImageName:@"img-avatar"
                                                         sessionImage:profileSessionImage
                                                             delegate:self
                                                               postId:post.identifier
                                                           isPostById:post.postedBy
                                                          isPostByPet:post.isPostByPet
                                                         postImageUrl:post.postUrl
                                                          primaryText:profileName
                                                        secondaryText:postDate
                                                      descriptionText:post.postDescription
                                                           statusText:post.getPostStatusString];
            }
        }
        else
        {
            cell = (LoadingCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kLoadingCellIdentifier
                                                                                      forIndexPath:indexPath];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.items.count)
    {
        Post *post = [self.items objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:kSegueComment sender:post];
    }
}

@end