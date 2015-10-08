//
//  ProfileHeaderCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "CircleImageView.h"
#import "Graphics.h"

@interface ProfileHeaderCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation ProfileHeaderCell

+ (CGFloat)cellHeight
{
    return 240.0f;
}

- (void)awakeFromNib
{
    TRACE_HERE;
    self.settingsButton.layer.borderColor = [[AppColorScheme white] CGColor];
    self.settingsButton.layer.borderWidth = 1.0f;
    self.settingsButton.layer.cornerRadius = 3.0f;
}

- (void)updateUserInfo:(CurrentUser *)user
{
    // TODO: Implement later
}

@end
