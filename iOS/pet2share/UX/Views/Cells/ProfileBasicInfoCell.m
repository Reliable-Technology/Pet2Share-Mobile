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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.formProtocol respondsToSelector:@selector(fieldIsDirty)])
        [self.formProtocol fieldIsDirty];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.formProtocol respondsToSelector:@selector(updateData:value:)])
    {
        if (textField == self.firstnameTxtField)
            [self.formProtocol updateData:kFirstNameKey value:self.firstName];
        else if (textField == self.lastNameTxtField)
            [self.formProtocol updateData:kLastNameKey value:self.lastName];
    }
}

#pragma mark - Public Instance Methods

- (NSString *)firstName
{
    if (![self.lastNameTxtField.text isEqualToString:kEmptyString] &&
        ![self.firstnameTxtField.text isEqualToString:NSLocalizedString(@"N/A", @"")])
        return self.firstnameTxtField.text;
    else return nil;
}

- (NSString *)lastName
{
    if (![self.lastNameTxtField.text isEqualToString:kEmptyString]
        && ![self.lastNameTxtField.text isEqualToString:NSLocalizedString(@"N/A", @"")])
        return self.lastNameTxtField.text;
    else return nil;
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
    if (dict[kCellNonEditText] != NSLocalizedString(@"N/A", @"")) self.usernameLabel.text = dict[kCellNonEditText];
    if (dict[kCellEditText1] != NSLocalizedString(@"N/A", @"")) self.firstnameTxtField.text = dict[kCellEditText1];
    if (dict[kCellEditText2] != NSLocalizedString(@"N/A", @"")) self.lastNameTxtField.text = dict[kCellEditText2];
    
    // Request Avatar Image
    Pet2ShareService *service = [Pet2ShareService new];
    [service loadImage:dict[kCellImageLink] completion:^(UIImage *image) {
        self.avatarImageView.image = image;
    }];
}

@end