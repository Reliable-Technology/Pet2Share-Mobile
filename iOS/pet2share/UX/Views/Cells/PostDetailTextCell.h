//
//  PostDetailTextCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellConstants.h"

@interface PostDetailTextCell : UITableViewCell

+ (CGFloat)cellHeightForText:(NSString *)text;
- (void)update:(NSString *)imageUrl postedName:(NSString *)postedName postedDate:(NSDate *)postedDate text:(NSString *)text;

@end
