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
#import "Pet2ShareService.h"
#import "CurrentUser.h"

@interface LoginVC () <FormProtocol, Pet2ShareServiceCallback>

@property (strong , nonatomic) LoginTableCtrl *loginTableCtrl;
@property (weak, nonatomic) IBOutlet RoundCornerButton *loginBtn;

@end

@implementation LoginVC

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
    
    [self.loginBtn addTarget:self action:@selector(loginBtnTapped:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTap
    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.loginTableCtrl clearPasswordField];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueLoginContainer])
    {
        self.loginTableCtrl = (LoginTableCtrl *)segue.destinationViewController;
        self.loginTableCtrl.formProtocol = self;
    }
}

#pragma mark - Private Instance Methods

- (void)mainViewTapped:(id)sender
{
    [self.loginTableCtrl resignAllTextFields];
}

- (void)loginBtnTapped:(id)sender
{
    [self.loginTableCtrl resignAllTextFields];
    [self.loginBtn showActivityIndicator];
    
//    // Get email and password from textfields
//    NSString *username = [self.loginTableCtrl email];
//    NSString *password = [self.loginTableCtrl password];
//    fTRACE("User: %@, Password: %@", username, password);
//    
//    // Check to see if username and password are not empty
//    if (![Utils validateNotEmpty:username] || ![Utils validateNotEmpty:password])
//    {
//        [Graphics alert:NSLocalizedString(@"Error", @"")
//                message:NSLocalizedString(@"Email or password can not be empty.", @"")
//                   type:ErrorAlert];
//    }
//    else if (![Utils validateEmail:username])
//    {
//        [Graphics alert:NSLocalizedString(@"Error", @"")
//                message:NSLocalizedString(@"Email is invalid.", @"")
//                   type:ErrorAlert];
//    }
//    else
//    {
//        Pet2ShareService *service = [Pet2ShareService new];
//        [service loginUser:self username:username password:password];
//    }
    
    [self performSegueWithIdentifier:kSegueMainView sender:self];
}

#pragma mark - <FormProtocol>

- (void)performAction
{
    [self loginBtnTapped:self.loginBtn];
}

#pragma mark - <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    [self.loginBtn hideActivityIndicator];
    
    if (objects.count == 1)
    {
        User *user = [objects objectAtIndex:0];
        CurrentUser *currentUser = [CurrentUser sharedInstance];
        currentUser.username = user.username;
        currentUser.password = user.password;
        currentUser.email = user.email;
        currentUser.alternateEmail = user.alternateEmail;
        currentUser.socialMediaId = user.socialMediaId;
        currentUser.socialMediaName = user.socialMediaName;
        currentUser.phone = user.phone;
        currentUser.socialMediaSource = user.socialMediaSource;
        currentUser.person = user.person;
        currentUser.userType = user.userType;
        currentUser.isAuthenticated = user.isAuthenticated;
        currentUser.isActive = user.isActive;
        
        [self.loginBtn hideActivityIndicator];
        [self performSegueWithIdentifier:kSegueMainView sender:self];
    }
    else
    {
       [Graphics alert:NSLocalizedString(@"Error", @"")
               message:NSLocalizedString(@"Unknown Error. Try again!", @"")
                  type:ErrorAlert];
    }
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
    [self.loginBtn hideActivityIndicator];
}

@end
