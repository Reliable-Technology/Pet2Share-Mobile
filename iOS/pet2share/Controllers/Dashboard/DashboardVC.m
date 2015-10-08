//
//  DashboardVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "DashboardVC.h"
#import "AppColor.h"
#import "Graphics.h"

static NSString * const kImageIconName = @"icon-profile";

@interface DashboardVC ()
{
    CGRect _profileImageBounds;
}

@end

@implementation DashboardVC

static NSString * const kCellIdentifier = @"cellidentifier";
static NSString * const kCellNibName    = @"DashboardCollectionCell";

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    fTRACE(@"Segue Identifier: %@", segue.identifier);
}

- (void)dealloc
{
    TRACE_HERE;
}

@end