//
//  ProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileVC.h"
#import "Utils.h"
#import "AppColorScheme.h"
#import "Pet2ShareUser.h"

@interface ProfileVC ()

@end

@implementation ProfileVC

static NSString * const kHeaderIdentifier       = @"profileheadercell";
static NSString * const kHeaderNibName          = @"ProfileHeaderCell";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _transitionManager = [TransitionManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:kHeaderNibName bundle:nil]
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:kHeaderIdentifier];
    self.collectionView.backgroundColor = [AppColorScheme systemLightGray];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:self.getEditSegueIdentifier])
    {
        UIViewController *viewController = segue.destinationViewController;
        viewController.transitioningDelegate = self.transitionManager;
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark - Overriden Instance Methods

- (NSString *)getProfileImageUrl
{
    // Implemeted at subclass
    return kEmptyString;
}

- (NSString *)getProfileCoverImageUrl
{
    // Implemeted at subclass
    return kEmptyString;
}

-  (NSString *)getProfileName
{
    // Implement at subclass
    return kEmptyString;
}

- (NSString *)getEditSegueIdentifier
{
    // Implement at subclass
    return kEmptyString;
}

- (UIImage *)getProfileSessionAvatarImage
{
    return nil;
}

#pragma mark - <UICollectionViewDataSource>

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
            [cell loadDataWithProfileImageUrl:[self getProfileImageUrl]
                      profileImagePlaceHolder:@"img-avatar"
                                 sessionImage:[self getProfileSessionAvatarImage]
                                coverImageUrl:[self getProfileCoverImageUrl]
                                         name:[self getProfileName]
                             socialStatusInfo:nil];
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

#pragma mark - <CellButtonDelegate>

- (void)mainButtonTapped:(id)sender
{
    if (![Utils isNullOrEmpty:self.getEditSegueIdentifier])
    {
        [self performSegueWithIdentifier:self.getEditSegueIdentifier sender:self];
    }
}

@end