//
//  ProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileVC.h"
#import "AppColor.h"
#import "ProfileHeaderCell.h"
#import "PetCollectionCell.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "PetProfileVC.h"

static NSString * const kCellIdentifier     = @"petcollectioncell";
static NSString * const kHeaderIdentifier   = @"profileheadercell";
static NSString * const kHeaderNibName      = @"ProfileHeaderCell";
static NSString * const kCellNibName        = @"PetCollectionCell";

@interface ProfileVC () <ProfileHeaderDelegate>

@end

@implementation ProfileVC

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
    
    // Set title text attribute (Lobster Typeface)
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
 
    // Setup collection view
    [self.collectionView registerNib:[UINib nibWithNibName:kHeaderNibName bundle:nil]
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:kHeaderIdentifier];
    self.collectionView.backgroundColor = [AppColorScheme white];
    
    [self.items addObjectsFromArray:[Pet2ShareUser current].pets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueEditProfile])
    {
        TRACE_HERE;
    }
    else if ([segue.identifier isEqualToString:kSeguePetProfile])
    {
        PetProfileVC *viewController = (PetProfileVC *)segue.destinationViewController;
        viewController.pet = (Pet *)sender;
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark - Private Instance Methods

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]])
    {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell cellHeight]);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell cellHeight]-20.0f);
        [layout setupLayout:TwoColumns cellHeight:[PetCollectionCell cellHeight:5.0f] spacing:5.0f];
        layout.parallaxHeaderAlwaysOnTop = NO;
        layout.disableStickyHeaders = YES;
    }
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PetCollectionCell *cell =
    (PetCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                   forIndexPath:indexPath];
    @try
    {
        Pet *pet = [self.items objectAtIndex:indexPath.row];
        [cell setupView:pet];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader])
    {
        @try
        {
            ProfileHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                         withReuseIdentifier:kHeaderIdentifier
                                                                                forIndexPath:indexPath];
            Pet2ShareUser *currentUser = [Pet2ShareUser current];
            NSString *firstName = currentUser.person.firstName;
            NSString *lastName = currentUser.person.lastName;
            NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            [cell updateProfileAvatar:currentUser.person.avatarUrl name:name socialStatusInfo:nil];
            cell.delegate = self;
            
            return cell;
        }
        @catch (NSException *exception)
        {
            NSLog(@"%s: Exception: %@", __func__, exception.description);
        }
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegates>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    fTRACE(@"Tile Selected Index: %ld", indexPath.row);
    
    @try
    {
        Pet *pet = [self.items objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:kSeguePetProfile sender:pet];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
}

#pragma mark - <ProfileHeaderDelegate>

- (void)editProfile:(id)sender
{
    [self performSegueWithIdentifier:kSegueEditProfile sender:self];
}

@end