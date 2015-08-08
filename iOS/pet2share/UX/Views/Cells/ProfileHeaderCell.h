//
//  ProfileHeaderCell.h
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParseUser;

@interface ProfileHeaderCell : UICollectionViewCell

+ (CGFloat)headerHeight;
- (void)updateUserInfo:(ParseUser *)user;

@end
