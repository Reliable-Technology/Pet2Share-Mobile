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
#import "PostTextCollectionCell.h"
#import "LoadingCollectionCell.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "Utils.h"

@interface FeedCollectionVC () <Pet2ShareServiceCallback>
{
    NSInteger _pageNumber;
    BOOL _hasAllData;
    CGFloat _lastContentOffset;
    BOOL _isRequesting;
}

@end

@implementation FeedCollectionVC

static NSString * const kDataCellIdentifier     = @"petcollectioncell";
static NSString * const kDataCellNibName        = @"PostTextCollectionCell";
static NSString * const kLoadingCellIdentifier  = @"loadingcollectioncell";
static NSString * const kLoadingCellNibName     = @"LoadingCollectionCell";
static NSInteger const kNumberOfPostPerPage     = 10;

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
    
    [self.collectionView registerNib:[UINib nibWithNibName:kLoadingCellNibName bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kLoadingCellIdentifier];
    
    // Setup refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(requestData) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark -
#pragma mark  Web Services

- (void)requestData
{
    _isRequesting = YES;
    if (self.refreshControl.isRefreshing)
    {
        _pageNumber = 0;
        _hasAllData = NO;
    }
    
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
    if (objects.count == 0 || objects.count < kNumberOfPostPerPage) _hasAllData = YES;
    [self.items addObjectsFromArray:objects];
    [self.collectionView reloadData];
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
    [layout setupLayout:OneColumn cellHeight:[PostTextCollectionCell defaultHeight] spacing:5.0f];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [CollectionViewLayout getItemWidth:self.collectionView.frame.size.width layoutType:OneColumn spacing:5.0f];
    
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
            
            NSString *likeStringCount = post.postLikeCount == 1
            ? [NSString stringWithFormat:@"%ld Like", (long)post.postLikeCount]
            : [NSString stringWithFormat:@"%ld Likes", (long)post.postLikeCount];
            NSString *commentStringCount = post.postLikeCount == 1
            ? [NSString stringWithFormat:@"%ld Comment", (long)post.postCommentCount]
            : [NSString stringWithFormat:@"%ld Comments", (long)post.postCommentCount];
            NSString *likeComment = [NSString stringWithFormat:@"%@ • %@", likeStringCount, commentStringCount];
            
            [(PostTextCollectionCell *)cell loadDataWithImageUrl:post.user.profilePictureUrl
                                            placeHolderImageName:@"img-avatar"
                                                     primaryText:post.user.name
                                                   secondaryText:[Utils formatNSDateToString:post.dateAdded withFormat:kFormatDayOfWeekWithDateTime]
                                                 descriptionText:post.postDescription
                                                      statusText:likeComment];
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

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.items.count) return YES;
    else return NO;
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

#pragma mark -
#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection = ScrollDirectionNone;
    if (_lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else if (_lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    _lastContentOffset = scrollView.contentOffset.y;
    
    /*
    fTRACE(@"Scroll Direction: %d Content Size: %.2f Offset: %.2f, View Height: %.2f",
           scrollDirection, scrollView.contentSize.height,  _lastContentOffset, self.view.bounds.size.height); */
    
    if (_lastContentOffset > 0)
    {
        CGFloat offset = scrollView.contentSize.height - _lastContentOffset;
        if (scrollDirection == ScrollDirectionDown && offset < self.view.bounds.size.height && !_isRequesting)
        {
            [self requestData];
        }
    }
}

@end