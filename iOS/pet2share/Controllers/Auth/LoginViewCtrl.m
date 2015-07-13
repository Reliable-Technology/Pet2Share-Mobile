//
//  LoginViewCtrl.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "LoginViewCtrl.h"
#import "Graphics.h"
#import "AppColor.h"

@interface LoginViewCtrl () <BarButtonsProtocol>

@end

@implementation LoginViewCtrl

static NSString * const kLeftIconImageName  = @"icon-arrowback";

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:18.0f]}];
}

#pragma mark - <BarButtonsDelegate>

- (UIButton *)setupLeftBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight);
    [button setImage:[UIImage imageNamed:kLeftIconImageName] forState:UIControlStateNormal];
    return button;
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
