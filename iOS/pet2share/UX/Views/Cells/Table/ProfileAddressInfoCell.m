//
//  ProfileAddressInfoCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileAddressInfoCell.h"
#import "Graphics.h"

@interface ProfileAddressInfoCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *addressIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *cityIconImgView;

@property (weak, nonatomic) IBOutlet UITextField *addressTxtField;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtField;
@property (weak, nonatomic) IBOutlet UITextField *stateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTxtField;

@end

@implementation ProfileAddressInfoCell

+ (CGFloat)cellHeight
{
    return 132.0f;
}

#pragma mark - 
#pragma mark Life Cycle

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
    self.addressTxtField.delegate = self;
    self.cityTxtField.delegate = self;
    self.stateTxtField.delegate = self;
    self.zipCodeTxtField.delegate = self;
}

#pragma mark - 
#pragma mark <UITextFieldDelegate>

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
        if (textField == self.addressTxtField)
        {
            textField.text = [textField.text capitalizedString];
            [self.formProtocol updateData:kAddressKey value:self.homeAddress];
        }
        else if (textField == self.cityTxtField)
        {
            textField.text = [textField.text capitalizedString];
            [self.formProtocol updateData:kCityKey value:self.city];
        }
        else if (textField == self.stateTxtField)
        {
            textField.text = [textField.text uppercaseString];
            [self.formProtocol updateData:kStateKey value:self.state];
        }
        else if (textField == self.zipCodeTxtField)
        {
            [self.formProtocol updateData:kZipCodeKey value:self.zipCode];
        }
        else fTRACE(@"Error: Unrecognized TextField: %@", textField);
    }
}

#pragma mark -
#pragma mark Private Instance Methods

- (NSString *)homeAddress
{
    if (![self.addressTxtField.text isEqualToString:kEmptyString])
        return self.addressTxtField.text;
    else return nil;
}

- (NSString *)city
{
    if (![self.cityTxtField.text isEqualToString:kEmptyString])
        return self.cityTxtField.text;
    else return nil;
}

- (NSString *)state
{
    if (![self.stateTxtField.text isEqual:kEmptyString])
        return self.stateTxtField.text;
    else return nil;
}

- (NSString *)zipCode
{
    if (![self.zipCodeTxtField.text isEqual:kEmptyString])
        return self.zipCodeTxtField.text;
    else return nil;
}

#pragma mark -
#pragma mark Public Instance Methods

- (void)updateCell:(NSDictionary *)dict
{
    // Icon Images
    self.addressIconImgView.image = [Graphics tintImage:[UIImage imageNamed:dict[kAddressImageIconKey]]
                                              withColor:[AppColorScheme darkGray]];
    self.cityIconImgView.image = [Graphics tintImage:[UIImage imageNamed:dict[kCityImageIconKey]]
                                           withColor:[AppColorScheme darkGray]];
    
    // Labels
    self.addressTxtField.text = dict[kAddressKey];
    self.cityTxtField.text = dict[kCityKey];
    self.stateTxtField.text = dict[kStateKey];
    self.zipCodeTxtField.text = dict[kZipCodeKey];
}

@end