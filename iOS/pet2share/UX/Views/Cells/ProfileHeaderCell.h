//
//  ProfileHeaderCell.h
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileHeaderDelegate <NSObject>

@required
- (void)editProfile:(id)sender;

@end

@class Pet2ShareUser;

@interface ProfileHeaderCell : UICollectionViewCell

@property (nonatomic, weak) id<ProfileHeaderDelegate> delegate;

+ (CGFloat)cellHeight;
- (void)updateUserInfo:(Pet2ShareUser *)user;

@end
