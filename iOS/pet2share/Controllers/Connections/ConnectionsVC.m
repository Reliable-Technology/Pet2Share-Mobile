//
//  ConnectionsVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ConnectionsVC.h"
#import "AppColor.h"

@implementation ConnectionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Title
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
}

@end