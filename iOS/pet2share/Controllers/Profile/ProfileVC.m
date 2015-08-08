//
//  ProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileVC.h"
#import "ParseServices.h"

@implementation ProfileVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ParseUser *currentUser = [ParseUser currentUser];
    self.navigationItem.title = currentUser.username;
}

@end