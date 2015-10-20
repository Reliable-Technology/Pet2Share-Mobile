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
#import "CommentCollectionCell.h"
#import "PostTextCollectionCell.h"
#import "LoadingCollectionCell.h"

@interface CommentCollectionVC ()

@end

@implementation CommentCollectionVC

static NSString * const kCommentCellIdentifier  = @"commentcollectioncell";
static NSString * const kCommentCellNibName     = @"CommentCollectionCell";
static NSString * const kPostCellIdentifier     = @"profileheadercell";
static NSString * const kPostCellNibName        = @"PostTextCollectionCell";
static NSString * const kLoadingCellIdentifier  = @"loadingcollectioncell";
static NSString * const kLoadingCellNibName     = @"LoadingCollectionCell";
static NSString * const kCellReuseIdentifier    = @"cellIdentifier";

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kCommentCellIdentifier;
        self.customNibName = kCommentCellNibName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register extra cells
    [self.collectionView registerNib:[UINib nibWithNibName:kPostCellNibName bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kPostCellIdentifier];
    
    // Setup refresh control
    self.refreshControl = [UIRefreshControl new];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [self prepareCellData:self.post.comments];
}

#pragma mark -
#pragma mark Web Services

- (void)prepareCellData:(NSArray *)comments
{
    NSString *likeStringCount = self.post.postLikeCount == 1
    ? [NSString stringWithFormat:@"%ld Like", (long)self.post.postLikeCount]
    : [NSString stringWithFormat:@"%ld Likes", (long)self.post.postLikeCount];
    NSString *commentStringCount = self.post.postCommentCount == 1
    ? [NSString stringWithFormat:@"%ld Comment", (long)self.post.postCommentCount]
    : [NSString stringWithFormat:@"%ld Comments", (long)self.post.postCommentCount];
    NSString *postStatus = [NSString stringWithFormat:@"%@ • %@", likeStringCount, commentStringCount];
    
    NSString *postDate = [Utils formatNSDateToString:self.post.dateAdded withFormat:kFormatDayOfWeekWithDateTime];
    
    NSDictionary *profileCellDict = @{kCellClassName: kPostCellNibName,
                                      kCellNameKey: self.post.user.name ?: kEmptyString,
                                      kCellImageLink: self.post.user.profilePictureUrl ?: kEmptyString,
                                      kCellTextKey: self.post.postDescription,
                                      kCellDateKey: postDate,
                                      kCellPostStatusKey: postStatus,
                                      kCellReuseIdentifier: kPostCellIdentifier};
    [self.items addObject:profileCellDict];
    
    for (Comment *comment in comments)
    {
        NSString *commentDate = [Utils formatNSDateToString:comment.dateAdded withFormat:kFormatDayOfWeekWithDateTime];
        
        NSDictionary *profileCellDict = @{kCellClassName: kCommentCellNibName,
                                          kCellNameKey: comment.user.name ?: kEmptyString,
                                          kCellImageLink: comment.user.profilePictureUrl ?: kEmptyString,
                                          kCellDateKey: commentDate,
                                          kCellTextKey: comment.commentDescription,
                                          kCellReuseIdentifier: kCommentCellIdentifier};
        [self.items addObject:profileCellDict];
    }
}

- (void)refreshData
{
    TRACE_HERE;
}

#pragma mark -
#pragma mark Collection View

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    [layout setupLayout:OneColumn cellHeight:[CommentCollectionCell defaultHeight] spacing:5.0f];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [CollectionViewLayout getItemWidth:self.collectionView.frame.size.width layoutType:OneColumn spacing:5.0f];
    CGSize cellSize;
    NSDictionary *data = [self.items objectAtIndexedSubscript:indexPath.row];
    
    if (indexPath.row < self.items.count)
    {
        if (indexPath.row == 0)
        {
            cellSize = CGSizeMake(itemWidth, [PostTextCollectionCell heightByText:self.post.postDescription itemWidth:itemWidth]);
        }
        else
        {
            cellSize = CGSizeMake(itemWidth, [CommentCollectionCell heightByText:data[kCellTextKey] itemWidth:itemWidth]);
        }
    }
    else
    {
        cellSize = CGSizeMake(itemWidth, [LoadingCollectionCell height]);
    }
    
    DEBUG_SIZE("Cell Size: ", cellSize);
    
    return cellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfCells = self.items.count;
    
//    if (self.items.count == 0)
//    {
//        if (_hasAllData) numberOfCells = 0;
//        else numberOfCells = 1;
//    }
//    else
//    {
//        if (_hasAllData) numberOfCells = self.items.count;
//        else numberOfCells = self.items.count+1;
//    }
    
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
            NSDictionary *data = self.items[indexPath.row];
            NSString *reuseIdentifier = data[kCellReuseIdentifier];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            
            if ([reuseIdentifier isEqualToString:kPostCellIdentifier])
            {
                [(PostTextCollectionCell *)cell loadDataWithImageUrl:data[kCellImageLink]
                                                placeHolderImageName:@"img-avatar"
                                                         primaryText:data[kCellNameKey]
                                                       secondaryText:data[kCellDateKey]
                                                     descriptionText:data[kCellTextKey]
                                                          statusText:data[kCellPostStatusKey]];
                [(PostTextCollectionCell *)cell displayHeaderIndicator];
            }
            else if ([reuseIdentifier isEqualToString:kCommentCellIdentifier])
            {
                [(CommentCollectionCell *)cell loadDataWithImageUrl:data[kCellImageLink]
                                               placeHolderImageName:@"img-avatar"
                                                         headerText:data[kCellNameKey]
                                                    descriptionText:data[kCellTextKey]
                                                         statusText:data[kCellDateKey]];
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

@end
