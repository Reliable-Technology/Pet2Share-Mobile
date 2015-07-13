//
//  BaseNavViewCtrl.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "BaseNavViewCtrl.h"

@interface BaseNavViewCtrl ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation BaseNavViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // Config left bar button
    if ([self.barButtonsProtocol respondsToSelector:@selector(setupLeftBarButton)] && !self.leftBtn)
    {
        _leftBtn = [self.barButtonsProtocol setupLeftBarButton];
        if (self.leftBtn)
        {
            [self.leftBtn addTarget:self action:@selector(handleLeftButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
        }
        
    }
    
    // Config right bar button
    if ([self.barButtonsProtocol respondsToSelector:@selector(setupRightBarButton)] && !self.rightBtn)
    {
        _rightBtn = [self.barButtonsProtocol setupRightBarButton];
        if (self.rightBtn)
        {
            [self.rightBtn addTarget:self action:@selector(handleRightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        }
    }
}

- (void)dealloc
{
    TRACE_HERE;
    self.leftBtn = nil;
    self.rightBtn = nil;
}

#pragma mark - Public Instance Methods

- (void)handleLeftButtonEvent:(id)sender
{
    // Implement at subclass
}

- (void)handleRightButtonEvent:(id)sender
{
    // Implement at subclass
}

- (void)setLeftBarButtonTitle:(NSString *)text
{
    [self.leftBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setLeftBarButtonImage:(UIImage *)image
{
    [self.leftBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setRightBarButtonTitle:(NSString *)text
{
    [self.rightBtn setTitle:text forState:UIControlStateNormal];
}

- (void)setRightBarButtonImage:(UIImage *)image
{
    [self.rightBtn setImage:image forState:UIControlStateNormal];
}

@end
