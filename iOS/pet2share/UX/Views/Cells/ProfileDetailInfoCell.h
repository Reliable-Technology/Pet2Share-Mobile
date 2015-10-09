//
//  ProfileDetailInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

static NSString * const kCellImageIcon      = @"imageicon";
static NSString * const kCellEditText       = @"edittext";
static NSString * const kPhoneKey           = @"phone";
static NSString * const kDateOfBirthKey     = @"dateofbirth";
static NSString * const kAddressKey         = @"address";

@interface ProfileDetailInfoCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;

+ (CGFloat)cellHeight;
- (void)updateCell:(NSDictionary *)dict forTagKey:(NSString *)tagKey;

@end
