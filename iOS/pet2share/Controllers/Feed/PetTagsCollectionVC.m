//
//  PetTagsCollectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/16/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PetTagsCollectionVC.h"
#import "PetTagsCollectionCell.h"
#import "ActivityView.h"
#import "ParseServices.h"
#import "Graphics.h"

static CGFloat kCellSpacing                 = 10.0f;
static NSString * const kCellIdentifier     = @"pettagscollectioncell";
static NSString * const kCellNibName        = @"PetTagsCollectionCell";

@interface PetTagsCollectionVC () <PFQueryCallback>

@property (nonatomic, strong) ActivityView *activity;

@end

@implementation PetTagsCollectionVC

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
        
    _activity = [[ActivityView alloc] initWithView:self.collectionView];
    
    [self requestData];
}

#pragma mark - Parse Services

- (void)requestData
{
    // Show activity when there are no items;
    if ([self.items count] == 0)
    {
        [self.activity show];
    }
    
    // Remove all items
    [self.items removeAllObjects];
    
    PFQueryService *service = [PFQueryService new];
    [service getPets:self forUser:[ParseUser currentUser]];
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
    [layout setupLayout:OneColumn cellHeight:[PetTagsCollectionCell cellHeight] spacing:kCellSpacing];
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PetTagsCollectionCell *cell =
    (PetTagsCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                   forIndexPath:indexPath];
    @try
    {
        ParsePet *pet = [self.items objectAtIndex:indexPath.row];
        [cell setupView:pet];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

@end