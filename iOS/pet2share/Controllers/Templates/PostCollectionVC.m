//
//  PostCollectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PostCollectionVC.h"
#import "PostCollectionCell.h"
#import "ActivityView.h"
#import "ParseServices.h"
#import "Graphics.h"

static CGFloat kCellSpacing                 = 10.0f;
static NSString * const kCellIdentifier     = @"postcollectioncell";
static NSString * const kCellNibName        = @"PostCollectionCell";

@interface PostCollectionVC () <PFQueryCallback>

@property (nonatomic, strong) ActivityView *activity;

@end

@implementation PostCollectionVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kCellIdentifier;
        self.customNibName = kCellNibName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup activity bounds
    _activity = [[ActivityView alloc] initWithView:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Request Data
    [self requestData];
}

- (void)dealloc
{
    TRACE_HERE;
    self.activity = nil;
}

#pragma mark - Parse Services

- (void)requestData
{
    // Show activity when there are no items;
    if ([self.items count] == 0)
    {
        [self.activity show];
    }
    
    PFQueryService *service = [PFQueryService new];
    [service getPosts:self forPet:self.pet];
}

- (void)onQueryListSuccess:(NSArray *)objects
{
    [self.activity hide];
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:objects];
    [self.collectionView reloadData];
}

- (void)onQueryError:(NSError *)error
{
    [self.activity hide];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:error.description type:ErrorAlert];
}

#pragma mark - Layout

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    [layout setupLayout:OneColumn cellHeight:[PostCollectionCell cellHeight:kCellSpacing] spacing:kCellSpacing];
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCollectionCell *cell =
    (PostCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                    forIndexPath:indexPath];
    
    @try
    {
        ParsePost *post = [self.items objectAtIndex:indexPath.row];
        [cell setUpView:post];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

@end
