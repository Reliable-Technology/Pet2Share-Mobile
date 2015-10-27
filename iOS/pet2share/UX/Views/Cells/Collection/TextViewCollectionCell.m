//
//  ActionCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/24/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "TextViewCollectionCell.h"
#import "Graphics.h"
#import "PlaceHolderTextView.h"

@interface TextViewCollectionCell () <UITextViewDelegate>
{
    NSInteger _remainCharacters;
}

@property (weak, nonatomic) IBOutlet UILabel *remainCharactersLabel;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textView;
@property (strong, nonatomic) id<FormProtocol> formProtocol;

@end

@implementation TextViewCollectionCell

+ (CGFloat)height
{
    return 160.0f;
}

- (void)awakeFromNib
{
    _remainCharacters = kPostMaxCharacters;
    self.textView.delegate = self;
    [Graphics dropShadow:self shadowOpacity:0.5f shadowRadius:0.5f offset:CGSizeZero];
}

- (void)loadPlaceHolderText:(NSString *)placeHolderText delegate:(id<UITextViewDelegate>)delegate
{
    self.textView.placeholder = placeHolderText;
    self.textView.delegate = delegate;
}

#pragma mark - Private Instance Methods

- (void)updateRemainCharactersLabel
{
    NSInteger remainingChar = _remainCharacters > 0 ? _remainCharacters : 0;
    if (remainingChar == 1) self.remainCharactersLabel.text = [NSString stringWithFormat:@"%ld Character Left", (long)remainingChar];
    else self.remainCharactersLabel.text = [NSString stringWithFormat:@"%ld Characters Left", (long)remainingChar];
    [self.remainCharactersLabel reloadInputViews];
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < kPostMaxCharacters) return YES;
    else return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _remainCharacters = kPostMaxCharacters - textView.text.length;
    [self updateRemainCharactersLabel];
    
    if ([self.formProtocol respondsToSelector:@selector(performAction:)])
        [self.formProtocol performAction:self.textView.text];
}

#pragma mark - Public Instance Methods

- (void)loadCellWithPlaceholder:(NSString *)placeHolder
                 inputAccessory:(UIView *)inputAccessory
                       protocol:(id<FormProtocol>)protocol
{
    self.textView.text = kEmptyString;
    self.textView.placeholder = placeHolder;
    self.textView.inputAccessoryView = inputAccessory;
    self.formProtocol = protocol;
}

@end