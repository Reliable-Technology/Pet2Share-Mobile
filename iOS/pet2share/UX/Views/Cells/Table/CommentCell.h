//
//  CommentCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellConstants.h"

@interface CommentCell : UITableViewCell

+ (CGFloat)cellHeightForText:(NSString *)text;
- (void)update:(NSString *)imageUrl commentedName:(NSString *)commentedName commentText:(NSString *)commentText postedDate:(NSDate *)postedDate;

@end
