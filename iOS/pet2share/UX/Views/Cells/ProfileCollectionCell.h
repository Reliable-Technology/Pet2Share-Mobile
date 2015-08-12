//
//  ProfileCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 8/11/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParseUser;

@interface ProfileCollectionCell : UICollectionViewCell

+ (CGFloat)cellHeight;
- (void)setupView:(ParseUser *)user;

@end
