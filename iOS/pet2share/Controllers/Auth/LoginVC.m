//
//  LoginVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "LoginVC.h"
#import "Graphics.h"
#import "AppColor.h"
#import "RoundCornerButton.h"
#import "LoginTableCtrl.h"
#import "Utils.h"
#import "ParseServices.h"

@interface LoginVC () <BarButtonsProtocol, FormProtocol, PFQueryCallback>

@property (strong , nonatomic) LoginTableCtrl *loginTableCtrl;
@property (strong, nonatomic) TransitionManager *transitionManager;

@property (weak, nonatomic) IBOutlet RoundCornerButton *loginBtn;

@end

@implementation LoginVC

static NSString * const kLeftIconImageName  = @"icon-arrowback";

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
        _transitionManager = [TransitionManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
    
    [self.loginBtn addTarget:self action:@selector(loginBtnTapped:)
            forControlEvents:UIControlEventTouchUpInside];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueLoginContainer])
    {
        self.loginTableCtrl = segue.destinationViewController;
        self.loginTableCtrl.formProtocol = self;
    }
    else if ([segue.identifier isEqualToString:kSegueDashboard])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        navController.transitioningDelegate = self.transitionManager;
    }
}

#pragma mark - Private Instance Methods

- (void)loginBtnTapped:(id)sender
{
    [self.loginTableCtrl resignAllTextFields];
    
    // Get email and password from textfield
    NSString *username = [self.loginTableCtrl username];
    NSString *password = [self.loginTableCtrl password];
    fTRACE("User: %@, Password: %@", username, password);
    
    // Check to see if username is not empty
    if (![Utils validateNotEmpty:username] || ![Utils validateNotEmpty:password])
    {
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Username/password can not be empty.", @"")
                   type:ErrorAlert];
    }
    else
    {
        // Show loading activity on register button
        [self.loginBtn showActivityIndicator];
        
        // Perform registration. The database will store email as username.
        PFQueryService *service = [PFQueryService new];
        [service loginUser:self username:username password:password];
    }
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

#pragma mark - <FormProtocol>

- (void)performAction
{
    [self loginBtnTapped:self.loginBtn];
}

#pragma mark - <PFQueryCallback>

- (void)onQuerySuccess:(PFObject *)object
{
    fTRACE("Login Success: %@", [object description]);
    
    // Hide loading activity from register buttons (if any)
    if (self.loginBtn.isLoading) [self.loginBtn hideActivityIndicator];
    
    // Navigate to the mainView
    [self performSegueWithIdentifier:kSegueMainView sender:self];
}

- (void)onQueryError:(NSError *)error
{
    fTRACE("Login Error: %@", [error localizedDescription]);
    
    // Hide loading activity from register buttons (if any)
    if (self.loginBtn.isLoading) [self.loginBtn hideActivityIndicator];
    
    [Graphics alert:NSLocalizedString(@"Error", @"")
            message:[PFErrors getParseErrorMessage:(TBParseError)error.code]
               type:ErrorAlert];
}

@end
