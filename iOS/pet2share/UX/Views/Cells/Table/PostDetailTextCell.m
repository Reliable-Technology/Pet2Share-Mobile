//
//  PostDetailTextCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PostDetailTextCell.h"
#import "PostHeaderView.h"
#import "Utils.h"
#import "Graphics.h"

@interface PostDetailTextCell ()

@property (weak, nonatomic) IBOutlet PostHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PostDetailTextCell

+ (CGFloat)cellHeightForText:(NSString *)text
{
    CGFloat cellHeight = 150.0f;
    CGSize textSize = [Utils findHeightForText:text
                                   havingWidth:[Graphics getDeviceSize].width-16.0f*2
                                       andFont:[UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular]];
    
    DEBUG_SIZE("TextView Frame ", textSize);
    
    cellHeight = textSize.height+(150.0f-86.0f)+24.0f;
    
    return cellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        [self initCell];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initCell];
}

- (void)initCell
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)update:(NSString *)imageUrl postedName:(NSString *)postedName postedDate:(NSDate *)postedDate text:(NSString *)text
{
    [self.headerView updateHeaderView:imageUrl postedName:postedName postedDate:postedDate];
    self.textView.text = text;
    self.textView.textColor = [AppColorScheme darkGray];
    self.textView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
}

@end