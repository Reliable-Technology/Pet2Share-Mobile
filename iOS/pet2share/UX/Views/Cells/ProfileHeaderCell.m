//
//  ProfileHeaderCell.m
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "CircleImageView.h"
#import "ParseServices.h"
#import "Graphics.h"

@interface ProfileHeaderCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation ProfileHeaderCell

+ (CGFloat)headerHeight
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

- (void)updateUserInfo:(ParseUser *)user
{
    // Fetch the current user from network for newer information
    [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        ParseUser *currentUser = (ParseUser *)object;
        if (user)
        {
            // Fetch name label
            NSString *firstName = user.firstName ?: NSLocalizedString(@"First Name", @"");
            NSString *lastName = user.lastName ?: NSLocalizedString(@"Last Name", @"");
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            // Fetch avatar image view
            [PFQueryService loadImage:currentUser imageView:self.avatarImageView];
        }
        else
        {
            fTRACE(@"Cannot fetch user profile, error: %@", error.localizedDescription);
        }
    }];
}

@end
