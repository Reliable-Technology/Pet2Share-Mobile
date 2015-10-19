//
//  InputTableView.m
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "InputTableView.h"

@interface InputTableView()

@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;

@end

@implementation InputTableView

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (UIView *)inputAccessoryView
{
    if (!_inputAccessoryView)
    {
        _inputAccessoryView = [[KeyboardBar alloc] initWithDelegate:self.keyboardBarDelegate];
    }
    return _inputAccessoryView;
}

@end
