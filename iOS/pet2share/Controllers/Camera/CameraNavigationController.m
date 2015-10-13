//
//  CameraNavigationController.m
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
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
