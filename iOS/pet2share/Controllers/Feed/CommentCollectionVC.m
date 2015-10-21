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
#import "CommentCollectionCell.h"
#import "PostTextCollectionCell.h"
#import "NoDataCollectionCell.h"
#import "OrderedDictionary.h"

@interface CommentCollectionVC () <Pet2ShareServiceCallback>

@property (nonatomic, strong) MutableOrderedDictionary *cellDict;

@end

@implementation CommentCollectionVC

static NSString * const kCommentCellIdentifier  = @"commentcollectioncell";
static NSString * const kCommentCellNibName     = @"CommentCollectionCell";
static NSString * const kPostCellIdentifier     = @"posttextcell";
static NSString * const kPostCellNibName        = @"PostTextCollectionCell";
static NSString * const kNoDataCellIdentifier   = @"nodatacell";
static NSString * const kNoDataCellNibName      = @"NoDataCollectionCell";
static NSString * const kCellReuseIdentifier    = @"cellidentifier";
static CGFloat const kSpacing                   = 5.0f;

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kCommentCellIdentifier;
        self.customNibName = kCommentCellNibName;
        _cellDict = [MutableOrderedDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register extra cells
    [self.collectionView registerNib:[UINib nibWithNibName:kPostCellNibName bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kPostCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:kNoDataCellNibName bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:kNoDataCellIdentifier];
    
    // Preload data with existings comments
    [self prepareCellData:self.post.comments];
    
    // Request comments
    [self requestData];
}

#pragma mark -
#pragma mark Web Services

- (void)prepareCellData:(NSArray *)comments
{
    [self.cellDict removeAllObjects];
    
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
    [self.cellDict insertObject:@[profileCellDict] forKey:kPostCellIdentifier atIndex:0];
    
    NSMutableArray *commentList = [NSMutableArray array];
    
    if ([comments count] > 0)
    {
        for (Comment *comment in comments)
        {
            NSString *commentDate = [Utils formatNSDateToString:comment.dateAdded withFormat:kFormatDayOfWeekWithDateTime];
            
            NSDictionary *commentDict = @{kCellClassName: kCommentCellNibName,
                                          kCellNameKey: comment.user.name ?: kEmptyString,
                                          kCellImageLink: comment.user.profilePictureUrl ?: kEmptyString,
                                          kCellDateKey: commentDate,
                                          kCellTextKey: comment.commentDescription,
                                          kCellReuseIdentifier: kCommentCellIdentifier};
            [commentList addObject:commentDict];
        }
        [self.cellDict insertObject:commentList forKey:kCommentCellIdentifier atIndex:1];
    }
    else
    {
        [commentList addObject:@{kCellClassName: kNoDataCellNibName,
                                 kCellReuseIdentifier: kNoDataCellIdentifier,
                                 kCellTextKey:NSLocalizedString(@"No Comments", @"") }];
        [self.cellDict insertObject:commentList forKey:kNoDataCellIdentifier atIndex:1];
    }
    
    [self.collectionView reloadData];
}

- (void)requestData
{
    Pet2ShareService *service = [Pet2ShareService new];
    [service getComments:self postId:self.post.identifier];
}

- (void)onReceiveSuccess:(NSArray *)objects
{
    fTRACE(@"Number of Objects: %ld", objects.count);
    [self prepareCellData:objects];
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [self.refreshControl endRefreshing];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

#pragma mark -
#pragma mark Overriden Methods

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    [layout setupLayout:OneColumn cellHeight:[CommentCollectionCell defaultHeight] spacing:kSpacing];
}

- (void)didScrollOutOfBound
{
    // No Implementation
}

#pragma mark -
#pragma mark Collection View

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
    else if ([sectionKey isEqualToString:kCommentCellIdentifier] || [sectionKey isEqualToString:kNoDataCellIdentifier])
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
            cellSize = CGSizeMake(itemWidth, [NoDataCollectionCell height]);
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
        fTRACE("Section: %ld - Index: %ld", indexPath.section, indexPath.row);

        NSArray *data = self.cellDict[section];
        NSString *reuseIdentifier = [self.cellDict keyAtIndex:section];
        NSDictionary *cellDict;
        
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if ([reuseIdentifier isEqualToString:kPostCellIdentifier])
        {
            cellDict = data[0];
            [(PostTextCollectionCell *)cell loadDataWithImageUrl:cellDict[kCellImageLink]
                                            placeHolderImageName:@"img-avatar"
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
                                                     headerText:cellDict[kCellNameKey]
                                                descriptionText:cellDict[kCellTextKey]
                                                     statusText:cellDict[kCellDateKey]];
        }
        else if ([reuseIdentifier isEqualToString:kNoDataCellIdentifier])
        {
            cellDict = data[index];
            [(NoDataCollectionCell *)cell load:cellDict[kCellTextKey]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

@end
