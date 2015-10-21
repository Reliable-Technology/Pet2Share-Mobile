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
#import "Pet2ShareService.h"
#import "PostCollectionCell.h"
#import "AddEditPetProfileVC.h"

static CGFloat kCellSpacing                     = 5.0f;
static NSString * const kCellIdentifier         = @"postcollectioncell";
static NSString * const kCellNibName            = @"PostCollectionCell";
static NSString * const kLeftIconImageName      = @"icon-arrowback";

@interface PetProfileVC () <Pet2ShareServiceCallback>

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
    
    // Request Data
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueAddEditPetProfile])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddEditPetProfileVC *addEditProfileVC = (AddEditPetProfileVC *)navController.topViewController;
        if (addEditProfileVC)
        {
            addEditProfileVC.petProfileMode = EditPetProfile;
            addEditProfileVC.pet = self.pet;
        }
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark - Private Instance Methods

- (NSString *)getProfileImageUrl
{
    return self.pet.profilePictureUrl;
}

- (NSString *)getProfileCoverImageUrl
{
    return self.pet.coverPictureUrl;
}

-  (NSString *)getProfileName
{
    return self.pet.name;
}

- (NSString *)getEditSegueIdentifier
{
    return kSegueEditProfile;
}

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]])
    {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell height]);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, [ProfileHeaderCell height]-10.0f);
        [layout setupLayout:OneColumn cellHeight:[PostCollectionCell cellHeight:kCellSpacing] spacing:kCellSpacing];
        layout.parallaxHeaderAlwaysOnTop = NO;
        layout.disableStickyHeaders = YES;
    }
}

#pragma mark - Events

- (void)backBarButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Services

- (void)requestData
{
    // TODO: Hacking, need full implementation here
    if ([self.items count] == 0)
    {
        for (int i = 0; i < 5; i++)
        {
            [self.items addObject:@"Test"];
        }
    }
}

- (void)onReceiveSuccess:(NSArray *)objects
{
    fTRACE(@"Objects: %@", objects);
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    fTRACE(@"Error Message: %@", errorMessage.message);
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCollectionCell *cell =
    (PostCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                    forIndexPath:indexPath];
    return cell;
}

@end