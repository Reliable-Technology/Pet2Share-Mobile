//
//  ProfileVC.h
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewController.h"
#import "ProfileHeaderCell.h"

@interface ProfileVC : CollectionViewController <CellButtonDelegate>

@property (strong, nonatomic) TransitionManager *transitionManager;

- (NSString *)getProfileImageUrl;
- (NSString *)getProfileCoverImageUrl;
- (NSString *)getProfileName;
- (NSString *)getEditSegueIdentifier;

@end
