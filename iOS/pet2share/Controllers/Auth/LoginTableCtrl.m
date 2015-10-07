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

@property (weak, nonatomic) IBOutlet UITextField *usernameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;

@end

@implementation LoginTableCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.usernameTxtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Username", @"")
                                                                                  attributes:@{NSForegroundColorAttributeName:[AppColorScheme darkGray]}];
    self.passwordTxtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"")
                                                                                  attributes:@{NSForegroundColorAttributeName:[AppColorScheme darkGray]}];
    self.usernameTxtField.delegate = self;
    self.passwordTxtField.delegate = self;
    
    self.tableView.layer.cornerRadius = 3.f;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resignAllTextFields];
}

- (void)dealloc
{
    TRACE_HERE;
    self.usernameTxtField = nil;
    self.passwordTxtField = nil;
}

#pragma mark - Private Instance Methods

- (void)setupCustomClearButton:(UITextField *)textfield
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 10, 10);
    [button setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    textfield.rightView = button;
    textfield.rightViewMode = UITextFieldViewModeWhileEditing;
}

- (void)clearText:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]])
    {
        UITextField *textField = (UITextField *)sender;
        textField.text = kEmptyString;
    }
}

#pragma mark - Public Instance Methods

- (NSString *)username
{
    return self.usernameTxtField.text ? self.usernameTxtField.text : kEmptyString;
}

- (NSString *)password
{
    return self.passwordTxtField ? self.passwordTxtField.text : kEmptyString;
}

- (void)resignAllTextFields
{
    if ([self.usernameTxtField isFirstResponder]) [self.usernameTxtField resignFirstResponder];
    else if ([self.passwordTxtField isFirstResponder]) [self.passwordTxtField resignFirstResponder];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTxtField)
    {
        [self.passwordTxtField becomeFirstResponder];
    }
    else if (textField == self.passwordTxtField)
    {
        [textField resignFirstResponder];
        if ([self.formProtocol respondsToSelector:@selector(performAction)])
            [self.formProtocol performAction];
    }
    
    return YES;
}

@end