//
//  CommentCollectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CommentCollectionVC.h"
#import "Utils.h"
#import "WSConstants.h"
#import "CellConstants.h"
#import "AppColor.h"
#import "Graphics.h"
#import "Pet2ShareService.h"
#import "PostTextCollectionCell.h"
#import "CommentCollectionCell.h"
#import "ActionCollectionCell.h"
#import "OrderedDictionary.h"
#import "Pet2ShareUser.h"
#import "RoundCornerButton.h"

@interface CommentCollectionVC () <Pet2ShareServiceCallback, FormProtocol>

@property (nonatomic, strong) MutableOrderedDictionary *cellDict;
@property (nonatomic, strong) TransitionManager *transitionManager;
@property (nonatomic, strong) NSString *inputCommentText;

@end

@implementation CommentCollectionVC

static NSString * const kCommentCellIdentifier  = @"commentcollectioncell";
static NSString * const kCommentCellNibName     = @"CommentCollectionCell";
static NSString * const kPostCellIdentifier     = @"posttextcell";
static NSString * const kPostCellNibName        = @"PostTextCollectionCell";
static NSString * const kActionCellIndetifier   = @"actioncell";
static NSString * const kActionCellNibName      = @"ActionCollectionCell";
static NSString * const kCellReuseIdentifier    = @"cellidentifier";
static CGFloat const kSpacing                   = 5.0f;
static CGFloat const kToolbarHeight             = 44.0f;
static NSInteger const kGetCommentTag           = 100;
static NSInteger const kPostCommentTag          = 101;

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kCommentCellIdentifier;
        self.customNibName = kCommentCellNibName;
        _cellDict = [MutableOrderedDictionary dictionary];
        _transitionManager = [TransitionManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register extra cells
    [self.collectionView registerNib:[UINib nibWithNibName:kPostCellNibName bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kPostCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:kActionCellNibName bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kActionCellIndetifier];
    
    // Preload data with existings comments
    [self prepareCellData:self.post.comments];
    
    // Request comments
    [self getComments];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSeguePostNewComment])
    {
        UIViewController *controller = segue.destinationViewController;
        controller.transitioningDelegate = self.transitionManager;
    }
}

- (void)dealloc
{
    TRACE_HERE;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Events & Delegates


#pragma mark - Web Services

- (void)prepareCellData:(NSArray *)comments
{
    [self.cellDict removeAllObjects];
    
    NSString *postStatus = [self.post getPostStatusString];
    NSString *profileImageUrl = kEmptyString;
    NSString *profileName = kEmptyString;
    UIImage *profileSessionImage = nil;
    
    if (self.post.isPostByPet)
    {
        profileImageUrl = self.post.pet.profilePictureUrl ?: kEmptyString;
        profileName = self.post.pet.name ?:kEmptyString;
    }
    else
    {
        profileImageUrl = self.post.user.profilePictureUrl;
        profileName = self.post.user.name;
        if (self.post.user.identifier == [Pet2ShareUser current].identifier)
            profileSessionImage = [Pet2ShareUser current].getUserSessionAvatarImage;
    }

    NSMutableDictionary *profileCellDict = [NSMutableDictionary dictionary];
    profileCellDict[kCellClassName] = kPostCellNibName;
    profileCellDict[kCellNameKey] = profileName;
    profileCellDict[kCellImageLink] = profileImageUrl;
    profileCellDict[kCellTextKey] = self.post.postDescription ?: kEmptyString;
    profileCellDict[kCellDateKey] = [Utils formatNSDateToString:self.post.dateAdded withFormat:kFormatDayOfWeekWithDateTime];
    profileCellDict[kCellPostStatusKey] = postStatus;
    profileCellDict[kCellReuseIdentifier] = kPostCellIdentifier;
    if (profileSessionImage) profileCellDict[kCellSessionImageKey] = profileSessionImage;
    
    [self.cellDict insertObject:@[profileCellDict] forKey:kPostCellIdentifier atIndex:0];

    if (comments.count > 0)
    {
        UIImage *commentProfileSessionImage = nil;
        NSMutableArray *commentList = [NSMutableArray array];
        
        for (Comment *comment in comments)
        {
            if (comment.user.identifier == [Pet2ShareUser current].identifier)
                commentProfileSessionImage = [Pet2ShareUser current].getUserSessionAvatarImage;

            NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
            commentDict[kCellClassName] = kCommentCellNibName;
            commentDict[kCellNameKey] = comment.user.name ?: kEmptyString;
            commentDict[kCellImageLink] = comment.user.profilePictureUrl ?: kEmptyString;
            commentDict[kCellDateKey] = [Utils formatNSDateToString:comment.dateAdded withFormat:kFormatDayOfWeekWithDateTime];
            commentDict[kCellTextKey] = comment.commentDescription ?: kEmptyString;
            commentDict[kCellReuseIdentifier] = kCommentCellIdentifier;
            if (commentProfileSessionImage) commentDict[kCellSessionImageKey] = commentProfileSessionImage;
            [commentList addObject:commentDict];
        }
        [self.cellDict insertObject:commentList forKey:kCommentCellIdentifier atIndex:1];
        
        [self.cellDict insertObject:@[@{kCellClassName: kActionCellNibName,
                                      kCellReuseIdentifier: kActionCellIndetifier,
                                      kCellTextKey:NSLocalizedString(@"Add Comment", @"")}]
                             forKey:kActionCellIndetifier atIndex:2];
    }
    else
    {
        [self.cellDict insertObject:@[@{kCellClassName: kActionCellNibName,
                                        kCellReuseIdentifier: kActionCellIndetifier,
                                        kCellTextKey:NSLocalizedString(@"Add Comment", @"")}]
                             forKey:kActionCellIndetifier atIndex:1];
    }
    
    [self.collectionView reloadData];
}

- (void)getComments
{
    Pet2ShareService *service = [Pet2ShareService new];
    service.requestTag = kGetCommentTag;
    [service getComments:self postId:self.post.identifier];
}

- (void)postComments
{
    Pet2ShareService *service = [Pet2ShareService new];
    service.requestTag = kPostCommentTag;
    
    [service addComment:self postId:self.post.identifier
            commentById:[Pet2ShareUser current].identifier
       isCommentedByPet:NO
     commentDescription:self.inputCommentText];
}

- (void)onReceiveSuccess:(NSArray *)objects service:(Pet2ShareService *)service
{
    fTRACE(@"Number of Objects: %ld", (long)objects.count);
    
    switch (service.requestTag)
    {
        case kGetCommentTag:
            [self prepareCellData:objects];
            break;
            
        case kPostCommentTag:
            [self getComments];
            break;
        default:
            break;
    }
}

- (void)onReceiveError:(ErrorMessage *)errorMessage service:(Pet2ShareService *)service
{
    [self.refreshControl endRefreshing];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

#pragma mark - Private & Overriden Methods

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    [layout setupLayout:OneColumn cellHeight:[CommentCollectionCell defaultHeight] spacing:kSpacing];
}

- (void)didScrollOutOfBound
{
    // No Implementation
}

- (UIToolbar *)createCustomToolbar
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    RoundCornerButton *postButton = [[RoundCornerButton alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 80.0f, 32.0f)];
    postButton.activityPosition = Center;
    postButton.layer.backgroundColor = [AppColorScheme darkBlueColor].CGColor;
    postButton.layer.cornerRadius = 3.0f;
    postButton.titleLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
    [postButton setTitle:NSLocalizedString(@"Post", @"") forState:UIControlStateNormal];
    [postButton setTitle:NSLocalizedString(@"Post", @"") forState:UIControlStateHighlighted];
    [postButton addTarget:self action:@selector(postBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *postBtnItem = [[UIBarButtonItem alloc] initWithCustomView:postButton];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kToolbarHeight)];
    toolbar.items = [NSArray arrayWithObjects:flexibleSpace, postBtnItem, nil];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    return toolbar;
}

#pragma mark - Events

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
        [self.collectionView setContentInset:edgeInsets];
        [self.collectionView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.collectionView setContentInset:edgeInsets];
        [self.collectionView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)postBtnTapped:(id)sender
{
    fTRACE(@"Sender: %@", sender);
    [self.view endEditing:YES];
    [self postComments];
}

- (void)performAction
{
    // No Implementation
}

- (void)performAction:(id)data
{
    if ([data isKindOfClass:[NSString class]])
    {
        self.inputCommentText = (NSString *)data;
    }
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.cellDict count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *data = self.cellDict[section];
    return [data count];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    NSString *sectionKey = [self.cellDict keyAtIndex:section];
    if ([sectionKey isEqualToString:kPostCellIdentifier])
    {
        return kSpacing;
    }
    else if ([sectionKey isEqualToString:kCommentCellIdentifier] || [sectionKey isEqualToString:kActionCellIndetifier])
    {
        return 0.0f;
    }
    return kSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [CollectionViewLayout getItemWidth:self.collectionView.frame.size.width layoutType:OneColumn spacing:kSpacing];
    CGSize cellSize;
    NSArray *data = self.cellDict[indexPath.section];
    
    if (indexPath.section == 0)
    {
        cellSize = CGSizeMake(itemWidth, [PostTextCollectionCell heightByText:self.post.postDescription itemWidth:itemWidth]);
    }
    else
    {
        NSDictionary *commentDict = data[indexPath.row];
        
        if ([commentDict[kCellReuseIdentifier] isEqualToString:kCommentCellIdentifier])
            cellSize = CGSizeMake(itemWidth, [CommentCollectionCell heightByText:commentDict[kCellTextKey] itemWidth:itemWidth]);
        else
            cellSize = CGSizeMake(itemWidth, [ActionCollectionCell height]);
    }
    
    DEBUG_SIZE("Cell Size: ", cellSize);
    
    return cellSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    NSInteger index = indexPath.row;
    NSInteger section = indexPath.section;
    
    @try
    {
        fTRACE("Section: %ld - Index: %ld", (long)indexPath.section, (long)indexPath.row);

        NSArray *data = self.cellDict[section];
        NSString *reuseIdentifier = [self.cellDict keyAtIndex:section];
        NSDictionary *cellDict;
        
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if ([reuseIdentifier isEqualToString:kPostCellIdentifier])
        {
            cellDict = data[0];
            [(PostTextCollectionCell *)cell loadDataWithImageUrl:cellDict[kCellImageLink]
                                            placeHolderImageName:@"img-avatar"
                                                    sessionImage:cellDict[kCellSessionImageKey]
                                                     primaryText:cellDict[kCellNameKey]
                                                   secondaryText:cellDict[kCellDateKey]
                                                 descriptionText:cellDict[kCellTextKey]
                                                      statusText:cellDict[kCellPostStatusKey]];
            [(PostTextCollectionCell *)cell displayHeaderIndicator];
        }
        else if ([reuseIdentifier isEqualToString:kCommentCellIdentifier])
        {
            cellDict = data[index];
            [(CommentCollectionCell *)cell loadDataWithImageUrl:cellDict[kCellImageLink]
                                           placeHolderImageName:@"img-avatar"
                                                   sessionImage:cellDict[kCellSessionImageKey]
                                                     headerText:cellDict[kCellNameKey]
                                                descriptionText:cellDict[kCellTextKey]
                                                     statusText:cellDict[kCellDateKey]];
        }
        else if ([reuseIdentifier isEqualToString:kActionCellIndetifier])
        {
            cellDict = data[index];
            [(ActionCollectionCell *)cell loadCellWithPlaceholder:NSLocalizedString(@"Enter Comment...", @"")
                                                   inputAccessory:[self createCustomToolbar]
                                                         protocol:self];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

@end