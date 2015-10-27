//
//  TextFieldTableCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "TextFieldTableCell.h"
#import "Graphics.h"
#import "Constants.h"
#import "Utils.h"

@interface TextFieldTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSString *textFieldTag;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (assign, nonatomic) UIDatePickerMode datePickerMode;

@end

@implementation TextFieldTableCell

+ (CGFloat)cellHeight
{
    return 44.0f;
}

#pragma mark -
#pragma mark Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
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
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.textField.delegate = self;
    
    _datePicker = [UIDatePicker new];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-kcenturyInSeconds];
    [self.datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
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
        [self.formProtocol updateData:self.textFieldTag value:self.textFieldValue];
}

#pragma mark - Private Instance Methods

- (NSString *)textFieldValue
{
    if (![self.textField.text isEqualToString:@""]) return self.textField.text;
    else return nil;
}

- (void)updateDateField:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)self.textField.inputView;
    self.textField.text = [Utils formatNSDateToString:datePicker.date];
}

- (void)setTextFieldInputType:(TextFieldInputType)inputType
{
    switch (inputType)
    {
        case InputTypeDefault:
            self.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case InputTypeASCIICapable:
            self.textField.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        case InputTypeNumbersAndPunctuation:
            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case InputTypeURL:
            self.textField.keyboardType = UIKeyboardTypeURL;
            break;
        case InputTypeNumberPad:
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case InputTypePhonePad:
            self.textField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case InputTypeNamePhonePad:
            self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
            break;
        case InputTypeEmailAddress:
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case InputTypeDecimalPad:
            self.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case InputTypeTwitter:
            self.textField.keyboardType = UIKeyboardTypeTwitter;
            break;
        case InputTypeWebSearch:
            self.textField.keyboardType = UIKeyboardTypeWebSearch;
            break;
        case InputTypeDate:
        {
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            self.textField.inputView = self.datePicker;
            self.datePicker.date = [Utils formatStringToNSDate:self.textField.text withFormat:kFormatDateUS] ?: [NSDate date];
            break;
        }
        case InputTypeTime:
        {
            // TODO: No implementation at this point
            break;
        }
        default:
            self.textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}

#pragma mark - Public Instance Methods

- (void)updateTextField:(NSString *)text iconImageName:(NSString *)imageName tag:(NSString *)tag
{
    self.textFieldTag = tag;
    self.textField.text = text;
    self.iconImageView.image = [Graphics tintImage:[UIImage imageNamed:imageName]
                                         withColor:[AppColorScheme darkGray]];
}

- (void)updateTextField:(NSString *)text iconImageName:(NSString *)imageName tag:(NSString *)tag
              inputType:(TextFieldInputType)inputType
{
    [self updateTextField:text iconImageName:imageName tag:tag];
    [self setTextFieldInputType:inputType];
}

@end