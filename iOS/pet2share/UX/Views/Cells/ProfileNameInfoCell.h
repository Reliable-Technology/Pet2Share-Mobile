//
//  ProfileNameInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

static NSString * const kFirstNameImageIcon = @"firstnameimageicon";
static NSString * const kLastNameImageIcon  = @"lastnameimageicon";
static NSString * const kCellImageLink      = @"imagelink";
static NSString * const kFirstNameKey       = @"firstname";
static NSString * const kLastNameKey        = @"lastname";

@interface ProfileNameInfoCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;

+ (CGFloat)cellHeight;
- (void)updateCell:(NSDictionary *)dict;

@end
