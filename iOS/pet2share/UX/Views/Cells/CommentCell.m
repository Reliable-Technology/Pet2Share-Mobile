//
//  CommentCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CommentCell.h"
#import "CircleImageView.h"
#import "Utils.h"
#import "Graphics.h"
#import "Pet2ShareService.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation CommentCell

+ (CGFloat)cellHeightForText:(NSString *)text
{
    CGFloat cellHeight = 100.0f;
    CGSize textSize = [Utils findHeightForText:text
                                   havingWidth:[Graphics getDeviceSize].width-86.0f
                                       andFont:[UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular]];
    
    DEBUG_SIZE("TextView Frame ", textSize);
    
    cellHeight = textSize.height+(100.0f-61.0f)+16.0f;
    
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

#pragma mark -
#pragma mark Public Instance Methods

- (void)update:(NSString *)imageUrl commentedName:(NSString *)commentedName commentText:(NSString *)commentText postedDate:(NSDate *)postedDate
{
    Pet2ShareService *service = [Pet2ShareService new];
    self.avatarImageView.image = [UIImage imageNamed:@"img-avatar"];
    [service loadImage:imageUrl completion:^(UIImage *image) {
        self.avatarImageView.image = image ?: [UIImage imageNamed:@"img-avatar"];
    }];
    
    self.commentTextView.text = commentText;
    self.commentTextView.textColor = [AppColorScheme darkGray];
    self.commentTextView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    
    self.nameLabel.text = commentedName;
    self.dateLabel.text = [Utils formatNSDateToString:postedDate];
}


@end
