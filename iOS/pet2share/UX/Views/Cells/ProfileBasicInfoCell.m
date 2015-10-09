//
//  ProfileBasicInfoCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileBasicInfoCell.h"
#import "CircleImageView.h"
#import "Pet2ShareService.h"
#import "Graphics.h"

@interface ProfileBasicInfoCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *usernameIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *firstnameIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *lastnameIconImgView;
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxtField;

@end

@implementation ProfileBasicInfoCell

+ (CGFloat)cellHeight
{
    return 132.0f;
}

#pragma mark - Life Cycle

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
    self.firstnameTxtField.delegate = self;
    self.lastNameTxtField.delegate = self;
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(updateUserFirstName:lastName:)])
        [self.delegate updateUserFirstName:self.firstName lastName:self.lastName];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstnameTxtField)
        [self.lastNameTxtField becomeFirstResponder];
    else
        [textField resignFirstResponder];

    return YES;
}

#pragma mark - Public Instance Methods

- (NSString *)firstName
{
    if (self.firstnameTxtField.text && ![self.firstnameTxtField.text isEqualToString:NSLocalizedString(@"N/A", @"")])
        return self.firstnameTxtField.text;
    else
        return nil;
}

- (NSString *)lastName
{
    if (self.lastNameTxtField.text && ![self.lastNameTxtField.text isEqualToString:NSLocalizedString(@"N/A", @"")])
        return self.lastNameTxtField.text;
    else
        return nil;
}

- (void)resignAllTextFields
{
    if ([self.firstnameTxtField isFirstResponder]) [self.firstnameTxtField resignFirstResponder];
    else if ([self.lastNameTxtField isFirstResponder]) [self.lastNameTxtField resignFirstResponder];
}

- (void)updateCell:(NSDictionary *)dict
{
    // Icon Images
    self.usernameIconImgView.image = [Graphics tintImage:[UIImage imageNamed:dict[kCellImageIcon1]]
                                               withColor:[AppColorScheme darkGray]];
    self.firstnameIconImgView.image = [Graphics tintImage:[UIImage imageNamed:dict[kCellImageIcon2]]
                                                withColor:[AppColorScheme darkGray]];
    self.lastnameIconImgView.image = [Graphics tintImage:[UIImage imageNamed:dict[kCellImageIcon3]]
                                               withColor:[AppColorScheme darkGray]];
    
    // Labels & TextFields
    self.usernameLabel.text = dict[kCellNonEditText];
    self.firstnameTxtField.text = dict[kCellEditText1];
    self.lastNameTxtField.text = dict[kCellEditText2];
    
    // Request Avatar Image
    Pet2ShareService *service = [Pet2ShareService new];
    [service loadImage:dict[kCellImageLink] completion:^(UIImage *image) {
        self.avatarImageView.image = image;
    }];
}

@end