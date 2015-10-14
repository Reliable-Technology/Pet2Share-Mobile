//
//  ProfileBasicInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"
#import "CellButtonDelegate.h"

static NSString * const kUserNameImageIcon  = @"usernameimageicon";
static NSString * const kFirstNameImageIcon = @"firstnameimageicon";
static NSString * const kLastNameImageIcon  = @"lastnameimageicon";
static NSString * const kCellImageLink      = @"imagelink";
static NSString * const kUserNameKey        = @"username";
static NSString * const kFirstNameKey       = @"firstname";
static NSString * const kLastNameKey        = @"lastname";

@interface ProfileBasicInfoCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;
@property (nonatomic, weak) id<CellButtonDelegate> buttonDelegate;

+ (CGFloat)cellHeight;
- (void)updateCell:(NSDictionary *)dict;

@end
