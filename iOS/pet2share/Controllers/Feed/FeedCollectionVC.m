//
//  FeedCollectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "FeedCollectionVC.h"
#import "ActivityView.h"
#import "Graphics.h"
#import "Constants.h"
#import "PostTextCollectionCell.h"
#import "LoadingCollectionCell.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "Utils.h"
#import "EmptyDataView.h"

@interface FeedCollectionVC () <Pet2ShareServiceCallback>
{
    NSInteger _pageNumber;
    BOOL _hasAllData;
    BOOL _isRequesting;
}

@end

@implementation FeedCollectionVC

static CGFloat kCellSpacing                     = 5.0f;
static NSString * const kDataCellIdentifier     = @"posttextcollectioncell";
static NSString * const kDataCellNibName        = @"PostTextCollectionCell";
static NSString * const kLoadingCellIdentifier  = @"loadingcollectioncell";
static NSString * const kLoadingCellNibName     = @"LoadingCollectionCell";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kDataCellIdentifier;
        self.customNibName = kDataCellNibName;
        _pageNumber = 0;
        _hasAllData = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Extra cell
    [self.collectionView registerNib:[UINib nibWithNibName:kLoadingCellNibName bundle:nil]
          forCellWithReuseIdentifier:kLoadingCellIdentifier];
    
    // Empty Data View
    self.emptyDataView = [[EmptyDataView alloc] initWithFrame:CGRectMake(0, 0, [EmptyDataView width], [EmptyDataView height])];
    [self.emptyDataView updateViewWithFirstText:NSLocalizedString(@"YOU HAVE NO POST YET!", @"")
                                     secondText:NSLocalizedString(@"to add new post", @"")
                                  iconImageName:@"img-compose"];
    self.emptyDataView.center = CGPointMake(self.collectionView.frame.size.width/2,
                                            self.collectionView.frame.size.height/2 - 49);  // Offset the TabBar
    [self.collectionView addSubview:self.emptyDataView];
    [self.collectionView bringSubviewToFront:self.emptyDataView];
    
    // Setup refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    // Request data
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark -
#pragma mark  Web Services

- (void)refreshData
{
    _pageNumber = 0;
    _hasAllData = NO;
    [self requestData];
}

- (void)requestData
{
    [self.emptyDataView hide];
    
    if (_isRequesting) return;
    _isRequesting = YES;
    
    Pet2ShareService *service = [Pet2ShareService new];
    _pageNumber++;
    fTRACE(@"Page Number: %ld", (long)_pageNumber);
    [service getPostsByUser:self userId:[Pet2ShareUser current].identifier postCount:kNumberOfPostPerPage pageNumber:_pageNumber];
}

- (void)onReceiveSuccess:(NSArray *)objects
{
    _isRequesting = NO;
    fTRACE(@"Number of Objects: %ld", objects.count);
    if (self.refreshControl.isRefreshing || _pageNumber == 1)
    {
        [self.items removeAllObjects];
        [self.refreshControl endRefreshing];
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
    [self.refreshControl endRefreshing];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

#pragma mark -
#pragma mark Collection View

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    [layout setupLayout:OneColumn cellHeight:[PostTextCollectionCell defaultHeight] spacing:kCellSpacing];
}

- (void)didScrollOutOfBound
{
    [self requestData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [CollectionViewLayout getItemWidth:self.collectionView.frame.size.width layoutType:OneColumn spacing:kCellSpacing];
    
    if (indexPath.row < self.items.count)
    {
        Post *post = [self.items objectAtIndexedSubscript:indexPath.row];
        CGSize cellSize = CGSizeMake(itemWidth, [PostTextCollectionCell heightByText:post.postDescription itemWidth:itemWidth]);
        return cellSize;
    }
    else
    {
        return CGSizeMake(itemWidth, [LoadingCollectionCell height]);
    }
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
            cell = (PostTextCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                                       forIndexPath:indexPath];
            Post *post = [self.items objectAtIndex:indexPath.row];
            
            NSString *profileImageUrl = kEmptyString;
            NSString *profileName = kEmptyString;
            UIImage *sessionImage = nil;
            
            if (post.isPostByPet)
            {
                profileImageUrl = post.pet.profilePictureUrl;
                profileName = post.pet.name;
                sessionImage = [Pet2ShareUser current].petSessionAvatarImages[@(post.pet.identifier)];
            }
            else
            {
                profileImageUrl = post.user.profilePictureUrl;
                profileName = post.user.name;
                if (post.user.identifier == [Pet2ShareUser current].identifier)
                    sessionImage = [Pet2ShareUser current].getUserSessionAvatarImage;
            }
            
            [(PostTextCollectionCell *)cell loadDataWithImageUrl:profileImageUrl
                                            placeHolderImageName:@"img-avatar"
                                                    sessionImage:sessionImage
                                                     primaryText:profileName
                                                   secondaryText:[Utils formatNSDateToString:post.dateAdded withFormat:kFormatDayOfWeekWithDateTime]
                                                 descriptionText:post.postDescription
                                                      statusText:post.getPostStatusString];
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
        if ([self.collectionDelegate respondsToSelector:@selector(didSelectItem:)])
        {
            [self.collectionDelegate didSelectItem:post];
        }
    }
}

@end