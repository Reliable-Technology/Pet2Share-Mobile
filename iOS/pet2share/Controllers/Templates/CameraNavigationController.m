//
//  CameraNavigationController.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "CameraNavigationController.h"

@interface CameraNavigationController ()

@end

@implementation CameraNavigationController

- (void)viewDidLoad
{
    self.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.topViewController.presentedViewController)
    {
        return self.topViewController.presentedViewController.supportedInterfaceOrientations;
    }
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
