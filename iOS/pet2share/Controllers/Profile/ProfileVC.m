//
//  ProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileVC.h"

@interface ProfileVC ()

- (IBAction)closeButtonClicked:(id)sender;

@end

@implementation ProfileVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Profile", @"");
}

#pragma mark - Events

- (IBAction)closeButtonClicked:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end