//
//  KeyboardBar.h
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardBar;
@class PlaceHolderTextView;
@class RoundCornerButton;

@protocol KeyboardBarDelegate <NSObject>

- (void)keyboardBar:(KeyboardBar *)keyboardBar sendText:(NSString *)text;

@end

@interface KeyboardBar : UIToolbar

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate;

@property (strong, nonatomic) PlaceHolderTextView *textView;
@property (strong, nonatomic) RoundCornerButton *actionButton;
@property (weak, nonatomic) id<KeyboardBarDelegate> keyboardDelegate;

@end
