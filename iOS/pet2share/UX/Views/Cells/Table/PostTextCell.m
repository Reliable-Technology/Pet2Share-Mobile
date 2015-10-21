//
//  PostTextCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PostTextCell.h"
#import "Utils.h"
#import "Graphics.h"

@interface PostTextCell ()

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PostTextCell

static CGFloat const kCellHeight        = 90.0f;
static CGFloat const kTextOffset        = 24.0f;
static CGFloat const kSpacing           = 16.0f;

+ (CGFloat)cellHeightForText:(NSString *)text
{
    CGFloat cellHeight = kCellHeight;
    CGSize textSize = [Utils findHeightForText:text
                                   havingWidth:[Graphics getDeviceSize].width-kSpacing*2
                                       andFont:[UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular]];
    
    // DEBUG_SIZE("TextView Frame ", textSize);
    
    cellHeight = textSize.height+kTextOffset;

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

- (void)update:(NSString *)text
{
    self.textView.text = text;
    self.textView.textColor = [AppColorScheme darkGray];
    self.textView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
}

@end
