//
//  ProfileHeaderCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "CircleImageView.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "Graphics.h"

@interface ProfileHeaderCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialStatusInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileBtn;

@end

@implementation ProfileHeaderCell

#pragma mark - Life Cycle

+ (CGFloat)cellHeight
{
    return 240.0f;
}

- (void)awakeFromNib
{
    TRACE_HERE;
    self.editProfileBtn.layer.borderColor = [[AppColorScheme white] CGColor];
    self.editProfileBtn.layer.borderWidth = 1.0f;
    self.editProfileBtn.layer.cornerRadius = 3.0f;
    [self.editProfileBtn addTarget:self action:@selector(editProfileBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateProfileAvatar:(NSString *)url name:(NSString *)name socialStatusInfo:(NSString *)socialStatusInfo
{
    self.nameLabel.text = name ?: NSLocalizedString(@"N/A", @"");
    self.socialStatusInfoLabel.text = socialStatusInfo ?: NSLocalizedString(@"N/A", @"");
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service loadImage:url completion:^(UIImage *image) {
        self.avatarImageView.image = image ?:[UIImage imageNamed:@"img-avatar"];
    }];
}

#pragma mark - Events

- (void)editProfileBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(editButtonTapped:)])
    {
        [self.delegate performSelector:@selector(editButtonTapped:) withObject:sender];
    }
}

@end
