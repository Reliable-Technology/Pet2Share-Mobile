//
//  ProfileCollectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileCollectionVC.h"
#import "ProfileHeaderCell.h"
#import "PetCollectionCell.h"
#import "ParseServices.h"
#import "ActivityView.h"
#import "Graphics.h"
#import "PetPostsVC.h"

static NSString * const kCellIdentifier     = @"petcollectioncell";
static NSString * const kHeaderIdentifier   = @"profileheadercell";
static NSString * const kHeaderNibName      = @"ProfileHeaderCell";
static NSString * const kCellNibName        = @"PetCollectionCell";

@interface ProfileCollectionVC () <PFQueryCallback>

@property (nonatomic, strong) ActivityView *activity;

@end

@implementation ProfileCollectionVC

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
    
    // Register header view
    [self.collectionView registerNib:[UINib nibWithNibName:kHeaderNibName bundle:nil]
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:kHeaderIdentifier];
    
    _activity = [[ActivityView alloc] initWithView:self.collectionView];
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSeguePetPosts])
    {
        // Provide data for next screen here
    }
}

- (void)dealloc
{
    TRACE_HERE;
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
    [service getAllPets:self forUser:[ParseUser currentUser]];
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
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]])
    {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell headerHeight]);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell headerHeight]-20.0f);
        [layout setupLayout:TwoColumns cellHeight:[PetCollectionCell cellHeight] spacing:5.0f];
        layout.parallaxHeaderAlwaysOnTop = NO;
        layout.disableStickyHeaders = YES;
    }
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PetCollectionCell *cell =
    (PetCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                   forIndexPath:indexPath];
    @try
    {
        ParsePet *pet = [self.items objectAtIndex:indexPath.row];
        [cell setUpView:pet];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader])
    {
        ProfileHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                     withReuseIdentifier:kHeaderIdentifier
                                                                            forIndexPath:indexPath];
        [cell updateUserInfo:[ParseUser currentUser]];
        return cell;
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegates>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    fTRACE(@"Tile Selected Index: %ld", indexPath.row);
    [self performSegueWithIdentifier:kSeguePetPosts sender:self];
}

@end
