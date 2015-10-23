//
//  ProfileHeaderCell.h
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButtonDelegate.h"


@class Pet2ShareUser;

@interface ProfileHeaderCell : UICollectionViewCell

@property (nonatomic, weak) id<CellButtonDelegate> delegate;

+ (CGFloat)height;
- (void)loadDataWithProfileImageUrl:(NSString *)imageUrl
            profileImagePlaceHolder:(NSString *)placeHolder
                       sessionImage:(UIImage *)sessionImage
                      coverImageUrl:(NSString *)coverImageUrl
                               name:(NSString *)name
                   socialStatusInfo:(NSString *)socialStatusInfo;

@end
