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
@property (weak, nonatomic) IBOutlet UILabel *socialInfoLabel;
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

- (void)updateUserInfo:(Pet2ShareUser *)user
{
    Person *person = user.person;
    
    if (person)
    {
        // Fetch Name label
        NSString *firstName = user.person.firstName ?: NSLocalizedString(@"First Name", @"");
        NSString *lastName = user.person.lastName ?: NSLocalizedString(@"Last Name", @"");
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        
        // Fetch image
        Pet2ShareService *service = [Pet2ShareService new];
        [service loadImage:person.avatarUrl completion:^(UIImage *image) {
            [self.avatarImageView setImage:image];
        }];
    }
}

#pragma mark - Events

- (void)editProfileBtnTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(editProfile:)])
    {
        [self.delegate performSelector:@selector(editProfile:) withObject:sender];
    }
}

@end
