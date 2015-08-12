//
//  ConnectionsCollectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/11/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ConnectionsCollectionVC.h"
#import "ProfileCollectionCell.h"
#import "AppColor.h"
#import "ActivityView.h"
#import "ParseServices.h"
#import "Graphics.h"

static CGFloat kCellSpacing                 = 16.0f;
static NSString * const kCellIdentifier     = @"profilecollectioncell";
static NSString * const kCellNibName        = @"ProfileCollectionCell";

@interface ConnectionsCollectionVC () <PFQueryCallback>

@property (nonatomic, strong) ActivityView *activity;

@end

@implementation ConnectionsCollectionVC

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
    
    // Request Data
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Parse Services

- (void)requestData
{
    // Show activity when there are no items;
    if ([self.items count] == 0)
    {
        [self.activity show];
    }
    
    // Remove all current users (if any)
    [self.items removeAllObjects];
    
    PFQueryService *service = [PFQueryService new];
    [service getConnections:self forUser:[ParseUser currentUser]];
}

- (void)onQueryListSuccess:(NSArray *)objects
{
    [self.activity hide];
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
    [layout setupLayout:OneColumn cellHeight:[ProfileCollectionCell cellHeight] spacing:kCellSpacing];
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionCell *cell =
    (ProfileCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                       forIndexPath:indexPath];
    
    @try
    {
        ParseUser *user = [self.items objectAtIndex:indexPath.row];
        [cell setupView:user];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

@end