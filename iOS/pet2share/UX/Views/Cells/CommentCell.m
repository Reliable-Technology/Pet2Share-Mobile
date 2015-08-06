//
//  CommentCell.m
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "CommentCell.h"
#import "CircleImageView.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;

@end

@implementation CommentCell

#pragma mark - Life Cycle

+ (CGFloat)cellHeight
{
    return 100.0f;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
