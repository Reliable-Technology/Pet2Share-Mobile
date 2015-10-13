//
//  PetProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/10/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PetProfileVC.h"
#import "WSConstants.h"
#import "AppColor.h"
#import "ProfileHeaderCell.h"
#import "Pet2ShareService.h"
#import "PostCollectionCell.h"
#import "EditPetProfileVC.h"

static CGFloat kCellSpacing                     = 10.0f;
static NSString * const kHeaderIdentifier       = @"profileheadercell";
static NSString * const kCellIdentifier         = @"postcollectioncell";
static NSString * const kHeaderNibName          = @"ProfileHeaderCell";
static NSString * const kCellNibName            = @"PostCollectionCell";
static NSString * const kLeftIconImageName      = @"icon-arrowback";

@interface PetProfileVC () <Pet2ShareServiceCallback, ProfileHeaderDelegate>

@end

@implementation PetProfileVC

#pragma mark - 
#pragma mark Life Cycle

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
            
    // Custom Back button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight)];
    [backButton setImage:[UIImage imageNamed:kLeftIconImageName] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBarButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    // Setup collection view
    [self.collectionView registerNib:[UINib nibWithNibName:kHeaderNibName bundle:nil]
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:kHeaderIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:kCellNibName bundle:nil]
          forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.backgroundColor = [AppColorScheme white];
    
    // Request Data
    [self requestData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueEditPetProfile])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        EditPetProfileVC *editPetProfileVC = (EditPetProfileVC *)navController.topViewController;
        if (editPetProfileVC) editPetProfileVC.pet = self.pet;
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
        [layout setupLayout:OneColumn cellHeight:[PostCollectionCell cellHeight:kCellSpacing] spacing:kCellSpacing];
        layout.parallaxHeaderAlwaysOnTop = NO;
        layout.disableStickyHeaders = YES;
    }
}

- (void)requestData
{
    // TODO: Hacking, need full implementation here
    if ([self.items count] == 0)
    {
        for (int i = 0; i < 5; i++)
        {
            [self.items addObject:@"Test"];
            [self.collectionView reloadData];
        }
    }
}

#pragma mark -
#pragma mark Events

- (void)backBarButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    fTRACE(@"Objects: %@", objects);
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    fTRACE(@"Error Message: %@", errorMessage.message);
}

#pragma mark -
#pragma mark <UICollectionViewDataSource>

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
            [cell updateProfileAvatar:self.pet.profilePicture name:self.pet.name socialStatusInfo:nil];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCollectionCell *cell =
    (PostCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                    forIndexPath:indexPath];
    return cell;
}

#pragma mark -
#pragma mark <ProfileHeaderDelegate>

- (void)editProfile:(id)sender
{
    [self performSegueWithIdentifier:kSegueEditPetProfile sender:self];
}

@end
