//
//  TextViewTableCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "TextViewTableCell.h"
#import "Graphics.h"
#import "Utils.h"
#import "FormProtocol.h"

static CGFloat const kCellHeight        = 250.f;
static CGFloat const kTextViewHeight    = 198.0f;
static CGFloat const kTextViewOffset    = 40.0f;
static CGFloat const kSpacing           = 16.0f;

@interface TextViewTableCell () <UITextViewDelegate>
{
    NSInteger _remainCharacters;
}

@property (weak, nonatomic) IBOutlet UILabel *remainCharacterLabels;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *textViewTag;

@end

@implementation TextViewTableCell

#pragma mark - Life Cycle

+ (CGFloat)cellHeightForText:(NSString *)text
{
    CGFloat cellHeight = kCellHeight;
    CGSize textSize = [Utils findHeightForText:text
                                   havingWidth:[Graphics getDeviceSize].width-kSpacing*2
                                       andFont:[UIFont systemFontOfSize:14.0f weight:UIFontWeightRegular]];
    
    DEBUG_SIZE("TextView Frame ", textSize);
    
    if (textSize.height+kTextViewOffset > kTextViewHeight)
        cellHeight = textSize.height+(kCellHeight-kTextViewHeight)+kTextViewOffset;
    
    return cellHeight;
}

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
    _remainCharacters = kDescriptionMaxCharacters;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.delegate = self;
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.formProtocol respondsToSelector:@selector(fieldIsDirty)])
        [self.formProtocol fieldIsDirty];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < kDescriptionMaxCharacters) return YES;
    else return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _remainCharacters = kDescriptionMaxCharacters - textView.text.length;
    [self updateRemainCharactersLabel];
    
    if ([self.formProtocol respondsToSelector:@selector(updateData:value:)])
        [self.formProtocol updateData:self.textViewTag value:self.textView.text];
}

#pragma mark - Private Instance Methods

- (void)updateRemainCharactersLabel
{
    NSInteger remainingChar = _remainCharacters > 0 ? _remainCharacters : 0;
    if (remainingChar == 1) self.remainCharacterLabels.text = [NSString stringWithFormat:@"%ld Character Left", (long)remainingChar];
    else self.remainCharacterLabels.text = [NSString stringWithFormat:@"%ld Characters Left", (long)remainingChar];
    [self.remainCharacterLabels reloadInputViews];
}

#pragma mark - Public Instance Methods

- (void)updateCell:(NSString *)text tag:(NSString *)tag
{
    self.textView.text = text;
    self.textViewTag = tag;
    _remainCharacters = kDescriptionMaxCharacters - text.length;
    [self updateRemainCharactersLabel];
}

@end