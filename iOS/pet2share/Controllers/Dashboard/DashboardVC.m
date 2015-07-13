//
//  DashboardVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "DashboardVC.h"

@interface DashboardVC ()

- (IBAction)dismissView:(id)sender;

@end

@implementation DashboardVC

- (IBAction)dismissView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
