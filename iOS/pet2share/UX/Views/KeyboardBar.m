//
//  KeyboardBar.m
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "KeyboardBar.h"
#import "PlaceHolderTextView.h"
#import "RoundCornerButton.h"
#import "AppColorScheme.h"

@implementation KeyboardBar

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate
{
    self = [self init];
    self.keyboardDelegate = delegate;
    return self;
}

- (id)init
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(screen), 44);
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
        fixedSpace.width = 5.0f;
        
        if (!self.textView)
        {
            _textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width-90.0f, 30.0f)];
            _textView.placeholder = NSLocalizedString(@"Enter Comments...", @"");
            _textView.textAlignment = NSTextAlignmentLeft;
            _textView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
            _textView.layer.cornerRadius = 5.f;
            _textView.layer.borderColor = [AppColorScheme darkGray].CGColor;
            _textView.tintColor = [AppColorScheme darkGray];
        }
        
        UIBarButtonItem *textFieldBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.textView];
        
        RoundCornerButton *postBtn = [[RoundCornerButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 36.0f)];
        postBtn.activityPosition = Center;
        postBtn.layer.backgroundColor = [AppColorScheme clear].CGColor;
        postBtn.tintColor = [AppColorScheme darkBlueColor];
        postBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightBold];
        [postBtn setTitle:NSLocalizedString(@"Post", @"") forState:UIControlStateNormal];
        [postBtn setTitleColor:[AppColorScheme darkBlueColor] forState:UIControlStateNormal];
        [postBtn addTarget:self action:@selector(postBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *postBtnItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
        
        self.items = [NSArray arrayWithObjects:textFieldBtnItem, postBtnItem, nil];
        self.barStyle = UIBarStyleDefault;
        [self sizeToFit];
        
    }
    return self;
}

- (void)postBtnTapped:(id)sender
{
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardBar:sendText:)])
        [self.keyboardDelegate keyboardBar:self sendText:self.textView.text];
}

@end
