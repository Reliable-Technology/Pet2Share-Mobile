//
//  ImagePostVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ImagePostVC.h"
#import "CircleImageView.h"
#import "Graphics.h"
#import "ParseServices.h"

@interface ImagePostVC () <BarButtonsProtocol, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *postTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

- (IBAction)dismissView:(id)sender;

@end

@implementation ImagePostVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    self.title = NSLocalizedString(@"Share Moment", @"");
    
    [Graphics dropShadow:self.headerView shadowOpacity:0.85f shadowRadius:1.0f offset:CGSizeMake(0.0f, 1.0f)];
    
    // Avatar Image View
    [PFQueryService loadImage:[ParseUser currentUser] imageView:self.avatarImageView];
    
    // Post Image View
    [self.postImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.postImageView.image = self.image;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.postTitleTextField becomeFirstResponder];
}

#pragma mark - Events

- (IBAction)dismissView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <BarButtonsProtocol>

- (UIButton *)setupRightBarButton
{
    // TODO: Postting Button
    return nil;
}

- (void)handleRightButtonEvent:(id)sender
{
    // TODO: Implement later
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.postTitleTextField)
    {
        [textField resignFirstResponder];
        // TODO: Perform Posting
    }
    
    return YES;
}

@end
