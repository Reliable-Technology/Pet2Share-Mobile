//
//  ProfileCell.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileCell.h"
#import "CircleImageView.h"
#import "RoundCornerButton.h"
#import "ParseServices.h"
#import "Graphics.h"

@interface ProfileCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet RoundCornerButton *addFriendButton;

@end

@implementation ProfileCell

+ (CGFloat)cellHeight
{
    return 72.0f;
}

- (void)awakeFromNib
{
    [self.addFriendButton addTarget:self action:@selector(addFriendButtonClicked)
                   forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)addFriendButtonClicked
{
    [Graphics alert:NSLocalizedString(@"Take a break!", @"")
            message:NSLocalizedString(@"Platform currently does not support this feature yet!", @"")
               type:WarningAlert];
}

#pragma mark - Public Instance Methods

- (void)setupView:(ParseUser *)user
{
    // User name
    NSString *firstName = user.firstName ?: NSLocalizedString(@"First Name", @"");
    NSString *lastName = user.lastName ?: NSLocalizedString(@"Last Name", @"");
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    // User avatar image
    self.avatarImageView.image = [UIImage imageNamed:@"img-avatar"];
    [PFQueryService loadImageFile:user.avatarImage imageView:self.avatarImageView completion:nil];
}

@end