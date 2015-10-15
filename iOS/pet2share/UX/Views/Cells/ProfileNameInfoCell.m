//
//  ProfileNameInfoCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileNameInfoCell.h"
#import "Pet2ShareService.h"
#import "Graphics.h"
#import "CircleImageView.h"

@interface ProfileNameInfoCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *firstnameIconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *lastnameIconImgView;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTxtField;
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImgView;

- (IBAction)editAvatarImageBtnTapped:(id)sender;

@end

@implementation ProfileNameInfoCell

+ (CGFloat)cellHeight
{
    return 88.0f;
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
    self.firstnameTxtField.delegate = self;
    self.lastnameTxtField.delegate = self;
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
        if (textField == self.firstnameTxtField)
        {
            textField.text = [textField.text capitalizedString];
            [self.formProtocol updateData:kFirstNameKey value:self.firstName];
        }
        else if (textField == self.lastnameTxtField)
        {
            textField.text = [textField.text capitalizedString];
            [self.formProtocol updateData:kLastNameKey value:self.lastName];
        }
        else fTRACE(@"Error: Unrecognized TextField: %@", textField);
    }
}

#pragma mark -
#pragma mark Private Instance Methods

- (NSString *)firstName
{
    if (![self.firstnameTxtField.text isEqualToString:kEmptyString])
        return self.firstnameTxtField.text;
    else return nil;
}

- (NSString *)lastName
{
    if (![self.lastnameTxtField.text isEqualToString:kEmptyString])
        return self.lastnameTxtField.text;
    else return nil;
}

#pragma mark -
#pragma mark Public Instance Methods

- (void)updateCell:(NSDictionary *)dict
{
    // Icon Images
    self.firstnameIconImgView.image = [Graphics tintImage:[UIImage imageNamed:dict[kFirstNameImageIcon]]
                                                withColor:[AppColorScheme darkGray]];
    self.lastnameIconImgView.image = [Graphics tintImage:[UIImage imageNamed:dict[kLastNameImageIcon]]
                                               withColor:[AppColorScheme darkGray]];
    
    // Labels & TextFields
    self.firstnameTxtField.text = dict[kFirstNameKey];
    self.lastnameTxtField.text = dict[kLastNameKey];
    
    // If there is a current session image (captured by camera or selected from Photos), use
    // this image instead. Otherwise, use cached data or loaded from the server.
    if (dict[kCellAvatarImage])
    {
        self.avatarImgView.image = dict[kCellAvatarImage];
    }
    else
    {
        Pet2ShareService *service = [Pet2ShareService new];
        [service loadImage:dict[kCellImageLink] completion:^(UIImage *image) {
            self.avatarImgView.image = image ?: [UIImage imageNamed:@"img-avatar"];
        }];
    }
}

- (IBAction)editAvatarImageBtnTapped:(id)sender
{
    if ([self.buttonDelegate respondsToSelector:@selector(editButtonTapped:)])
    {
        [self.buttonDelegate performSelector:@selector(editButtonTapped:) withObject:sender];
    }
}

@end
