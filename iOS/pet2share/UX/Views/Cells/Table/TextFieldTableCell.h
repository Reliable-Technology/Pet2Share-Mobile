//
//  TextFieldTableCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"
#import "CellConstants.h"

typedef NS_ENUM(NSInteger, TextFieldInputType)
{
    InputTypeDefault,
    InputTypeASCIICapable,
    InputTypeNumbersAndPunctuation,
    InputTypeURL,
    InputTypeNumberPad,
    InputTypePhonePad,
    InputTypeNamePhonePad,
    InputTypeEmailAddress,
    InputTypeDecimalPad,
    InputTypeTwitter,
    InputTypeWebSearch,
    InputTypeDate,
    InputTypeTime
};

@interface TextFieldTableCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;

+ (CGFloat)cellHeight;

- (void)updateTextField:(NSString *)text iconImageName:(NSString *)imageName tag:(NSString *)tag;
- (void)updateTextField:(NSString *)text iconImageName:(NSString *)imageName tag:(NSString *)tag
              inputType:(TextFieldInputType)inputType;

@end
