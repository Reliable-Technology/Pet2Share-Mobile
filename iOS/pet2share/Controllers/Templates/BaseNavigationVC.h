//
//  BaseNavigationVC.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarButtonsProtocol.h"

@interface BaseNavigationVC : UIViewController

@property (nonatomic, weak) id<BarButtonsProtocol> barButtonsProtocol;

- (void)handleLeftButtonEvent:(id)sender;
- (void)handleRightButtonEvent:(id)sender;
- (void)setLeftBarButtonTitle:(NSString *)text;
- (void)setLeftBarButtonImage:(UIImage *)image;
- (void)setRightBarButtonTitle:(NSString *)text;
- (void)setRightBarButtonImage:(UIImage *)image;

@end
