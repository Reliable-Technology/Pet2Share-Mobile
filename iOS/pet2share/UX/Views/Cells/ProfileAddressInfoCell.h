//
//  ProfileAddressInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

static NSString * const kAddressImageIconKey    = @"addressimageicon";
static NSString * const kCityImageIconKey       = @"cityimageicon";
static NSString * const kAddressKey             = @"address";
static NSString * const kCityKey                = @"city";
static NSString * const kStateKey               = @"state";
static NSString * const kZipCodeKey             = @"zipcode";

@interface ProfileAddressInfoCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;

+ (CGFloat)cellHeight;
- (void)updateCell:(NSDictionary *)dict;

@end
