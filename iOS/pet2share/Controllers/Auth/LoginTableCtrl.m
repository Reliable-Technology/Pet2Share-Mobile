//
//  LoginTableCtrl.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "LoginTableCtrl.h"
#import "AppColor.h"
#import "AppColorScheme.h"

@interface LoginTableCtrl () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;

@end

@implementation LoginTableCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailTxtField.delegate = self;
    self.passwordTxtField.delegate = self;
    
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
    self.emailTxtField = nil;
    self.passwordTxtField = nil;
}

#pragma mark - Private Instance Methods

- (void)clearText:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]])
    {
        UITextField *textField = (UITextField *)sender;
        textField.text = kEmptyString;
    }
}

#pragma mark - Public Instance Methods

- (NSString *)email
{
    return self.emailTxtField.text ? self.emailTxtField.text : kEmptyString;
}

- (NSString *)password
{
    return self.passwordTxtField ? self.passwordTxtField.text : kEmptyString;
}

- (void)resignAllTextFields
{
    if ([self.emailTxtField isFirstResponder]) [self.emailTxtField resignFirstResponder];
    else if ([self.passwordTxtField isFirstResponder]) [self.passwordTxtField resignFirstResponder];
}

- (void)clearPasswordField
{
    [self resignAllTextFields];
    self.passwordTxtField.text = kEmptyString;
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
    if (textField == self.emailTxtField)
    {
        [self.passwordTxtField becomeFirstResponder];
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