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

#pragma mark - Public Instance Methods

- (id)text
{
    return self.textField.text ? self.textField.text : [NSNull class];
}

- (void)updateCell:(NSDictionary *)dict
{
    // Icon Image
    self.iconImageView.image = [Graphics tintImage:[UIImage imageNamed:dict[kCellImageIcon]]
                                         withColor:[AppColorScheme darkGray]];
    
    // TextField
    self.textField.text = dict[kCellEditText];
}

@end
