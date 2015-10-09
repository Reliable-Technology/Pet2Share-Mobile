//
//  ProfileDetailInfoCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileDetailInfoCell.h"
#import "Graphics.h"

@interface ProfileDetailInfoCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSString *tagKey;

@end

@implementation ProfileDetailInfoCell

+ (CGFloat)cellHeight
{
    return 44.0f;
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
    self.textField.delegate = self;
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
        [self.formProtocol updateData:self.tagKey value:self.fieldValue];
}

#pragma mark - Public Instance Methods

- (NSString *)fieldValue
{
    if (self.textField.text && ![self.textField.text isEqualToString:NSLocalizedString(@"N/A", @"")])
        return self.textField.text;
    else return nil;
}

- (void)updateCell:(NSDictionary *)dict forTagKey:(NSString *)tagKey
{
    self.tagKey = tagKey;
    self.iconImageView.image = [Graphics tintImage:[UIImage imageNamed:dict[kCellImageIcon]]
                                         withColor:[AppColorScheme darkGray]];
    self.textField.text = dict[kCellEditText];
}

@end
