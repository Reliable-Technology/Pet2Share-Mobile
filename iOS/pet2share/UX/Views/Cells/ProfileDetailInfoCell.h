//
//  ProfileDetailInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kCellImageIcon      = @"imageicon";
static NSString * const kCellEditText       = @"edittext";

@interface ProfileDetailInfoCell : UITableViewCell

+ (CGFloat)cellHeight;
- (id)text;
- (void)updateCell:(NSDictionary *)dict;

@end
