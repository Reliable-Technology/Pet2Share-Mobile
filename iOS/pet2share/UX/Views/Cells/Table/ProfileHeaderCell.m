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
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation ProfileHeaderCell

#pragma mark - Life Cycle

+ (CGFloat)height
{
    return 200.0f;
}

- (void)awakeFromNib
{
    TRACE_HERE;
    self.backgroundColor = [Graphics lighterColorForColor:[AppColorScheme darkBlueColor]]; // This match the color scheme of navigation bar
    self.editProfileBtn.layer.borderColor = [[AppColorScheme white] CGColor];
    self.editProfileBtn.layer.borderWidth = 1.0f;
    self.editProfileBtn.layer.cornerRadius = 3.0f;
    [self.editProfileBtn addTarget:self action:@selector(editProfileBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadDataWithProfileImageUrl:(NSString *)imageUrl
            profileImagePlaceHolder:(NSString *)placeHolder
                       sessionImage:(UIImage *)sessionImage
                      coverImageUrl:(NSString *)coverImageUrl
                               name:(NSString *)name
                   socialStatusInfo:(NSString *)socialStatusInfo
{
    self.nameLabel.text = name ?: NSLocalizedString(@"N/A", @"");
    self.socialStatusInfoLabel.text = socialStatusInfo ?: NSLocalizedString(@"N/A", @"");
    
    if (sessionImage)
    {
        self.avatarImageView.image = sessionImage;
    }
    else
    {
        Pet2ShareService *profileImgUrlService = [Pet2ShareService new];
        [profileImgUrlService loadImage:imageUrl aspectRatio:Square completion:^(UIImage *image) {
            self.avatarImageView.image = image ?:[UIImage imageNamed:placeHolder];
        }];
    }

    /*
    Pet2ShareService *coverImgUrlService = [Pet2ShareService new];
    [coverImgUrlService loadImage:coverImageUrl completion:^(UIImage *image) {
        if (image) self.coverImageView.image = image;
    }]; */
}

#pragma mark - Events

- (void)editProfileBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mainButtonTapped:)])
    {
        [self.delegate performSelector:@selector(mainButtonTapped:) withObject:sender];
    }
}

@end
