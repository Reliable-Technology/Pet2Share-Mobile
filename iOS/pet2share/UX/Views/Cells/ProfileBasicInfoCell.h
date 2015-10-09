//
//  ProfileBasicInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

@protocol ProfileBasicInfoDelegate <NSObject>

@optional
- (void)updateUserFirstName:(NSString *)firstName lastName:(NSString *)lastName;

@end

static NSString * const kCellImageIcon1     = @"image1";
static NSString * const kCellImageIcon2     = @"image2";
static NSString * const kCellImageIcon3     = @"image3";
static NSString * const kCellImageLink      = @"imagelink";
static NSString * const kCellNonEditText    = @"nonedittext";
static NSString * const kCellEditText1      = @"edittext1";
static NSString * const kCellEditText2      = @"edittext2";

@interface ProfileBasicInfoCell : UITableViewCell

@property (nonatomic, weak) id<ProfileBasicInfoDelegate> delegate;

+ (CGFloat)cellHeight;
- (void)updateCell:(NSDictionary *)dict;

@end
