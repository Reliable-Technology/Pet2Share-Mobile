//
//  CommentCell.h
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CommentCellTheme)
{
    LightTheme,
    DarkTheme
};

@interface CommentCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)setCellTheme:(CommentCellTheme)cellTheme;

@end
