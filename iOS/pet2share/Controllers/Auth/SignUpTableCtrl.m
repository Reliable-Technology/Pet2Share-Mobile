//
//  SignUpTableCtrl.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "SignUpTableCtrl.h"
#import "AppColorScheme.h"

@interface SignUpTableCtrl () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignUpTableCtrl

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstnameTextField.delegate = self;
    self.lastnameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.tableView.layer.cornerRadius = 3.0f;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignAllTextFields];
}

- (void)dealloc
{
    TRACE_HERE;
    self.firstnameTextField = nil;
    self.lastnameTextField = nil;
    self.emailTextField = nil;
    self.passwordTextField = nil;
}

#pragma mark - Public Instance Methods

- (NSString *)firstname
{
    return self.firstnameTextField.text ?: kEmptyString;
}

- (NSString *)lastname
{
    return self.lastnameTextField.text ?: kEmptyString;
}

- (NSString *)email
{
    return self.emailTextField.text ?: kEmptyString;
}

- (NSString *)password
{
    return self.passwordTextField.text ?: kEmptyString;
}

- (void)resignAllTextFields
{
    if ([self.firstnameTextField isFirstResponder]) [self.firstnameTextField resignFirstResponder];
    if ([self.lastnameTextField isFirstResponder]) [self.lastnameTextField resignFirstResponder];
    if ([self.emailTextField isFirstResponder]) [self.emailTextField resignFirstResponder];
    if ([self.passwordTextField isFirstResponder]) [self.passwordTextField resignFirstResponder];
}

- (void)clearTextFields
{
    [self resignAllTextFields];
    self.firstnameTextField.text = kEmptyString;
    self.lastnameTextField.text = kEmptyString;
    self.emailTextField.text = kEmptyString;
    self.passwordTextField.text = kEmptyString;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstnameTextField)
    {
        [self.lastnameTextField becomeFirstResponder];
    }
    else if (textField == self.lastnameTextField)
    {
        [self.emailTextField becomeFirstResponder];
    }
    else if (textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        if ([self.formProtocol respondsToSelector:@selector(performAction)])
            [self.formProtocol performAction];
    }
    return YES;
}

@end
