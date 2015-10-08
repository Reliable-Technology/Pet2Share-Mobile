//
//  SignupVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "SignupVC.h"
#import "SignUpTableCtrl.h"
#import "Pet2ShareService.h"
#import "RoundCornerButton.h"
#import "Utils.h"
#import "Graphics.h"

@interface SignupVC () <FormProtocol, Pet2ShareServiceCallback>

@property (weak, nonatomic) IBOutlet RoundCornerButton *createAccountBtn;
@property (strong, nonatomic) SignUpTableCtrl *signupTableCtrl;

- (IBAction)closeBtnTapped:(id)sender;

@end

@implementation SignupVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.createAccountBtn addTarget:self action:@selector(signupBtnTapped:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTap
    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTapped:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueRegisterContainer])
    {
        self.signupTableCtrl = (SignUpTableCtrl *)segue.destinationViewController;
        self.signupTableCtrl.formProtocol = self;
    }
}

#pragma mark - <FormProtocol>

- (void)performAction
{
    [self signupBtnTapped:self.createAccountBtn];
}

#pragma mark - Events

- (IBAction)closeBtnTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signupBtnTapped:(id)sender
{
    [self.signupTableCtrl resignAllTextFields];
    
    // Get firstname, lastname, email and password from textfields
    NSString *firstname = [self.signupTableCtrl firstname];
    NSString *lastname = [self.signupTableCtrl lastname];
    NSString *username = [self.signupTableCtrl email];
    NSString *password = [self.signupTableCtrl password];
    
    // Check to see if the username and password are not empty
    if (![Utils validateNotEmpty:username] || ![Utils validateNotEmpty:password])
    {
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Email or password can not be empty.", @"")
                   type:ErrorAlert];
    }
    else if (![Utils validateEmail:username])
    {
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Email is invalid.", @"")
                   type:ErrorAlert];
    }
    else
    {
        Pet2ShareService *service = [Pet2ShareService new];
        [service registerUser:self firstname:firstname
                     lastname:lastname username:username
                     password:password phone:nil];
        [self.createAccountBtn showActivityIndicator];
    }
}

- (void)mainViewTapped:(id)sender
{
    [self.signupTableCtrl resignAllTextFields];
}

#pragma mark - <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    fTRACE("Objects: %@", objects);
    [self.createAccountBtn hideActivityIndicator];
    
    if (objects.count == 1)
    {
        [self.createAccountBtn hideActivityIndicator];
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
    [self.createAccountBtn hideActivityIndicator];
}

@end