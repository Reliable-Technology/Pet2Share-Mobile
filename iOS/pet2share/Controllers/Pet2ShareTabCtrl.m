//
//  Pet2ShareTabCtrl.m
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Pet2ShareTabCtrl.h"
#import "ParseServices.h"

@interface Pet2ShareTabCtrl ()

@property (strong, nonatomic) TransitionManager *transitionManager;

@end

@implementation Pet2ShareTabCtrl

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _transitionManager = [TransitionManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /// ------------------------------------------
    /// FOR DEVELOPMENT PURPOSE ONLY. FORCE LOGOUT
    /// ------------------------------------------
    // [PFUser logOut];
    /// ------------------------------------------
    
    // Analyticst
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![PFUser currentUser].isAuthenticated)
    {
        [[PFUser currentUser] fetchInBackground];
        [self performSegueWithIdentifier:kSegueIntroPages sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueIntroPages])
    {
        UIViewController *controller = segue.destinationViewController;
        controller.transitioningDelegate = self.transitionManager;
    }
}

@end
