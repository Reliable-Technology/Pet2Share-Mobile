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
#import "ActivityView.h"
#import <DBCamera/UIImage+Crop.h>

@interface ImagePostVC () <UITextFieldDelegate, PFQueryCallback, BarButtonsProtocol>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *postTitleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) ActivityView *activity;

@property (strong, nonatomic) NSMutableArray *pets;

- (IBAction)dismissView:(id)sender;

@end

@implementation ImagePostVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
        _pets = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    self.title = NSLocalizedString(@"Share Moment", @"");
        
    // Post Image View
    [self.postImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.postImageView.image = self.image;
    
    [self.postTitleTextField becomeFirstResponder];
    
    PFQueryService *service = [PFQueryService new];
    [service getPets:self forUser:[ParseUser currentUser]];
    
    _activity = [[ActivityView alloc] initWithView:self.view];
}

#pragma mark - Events

- (IBAction)dismissView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)setupRightBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0.0f, 0.0f, kBarButtonWidth, kBarButtonHeight);
    [button setImage:[Graphics tintImage:[UIImage imageNamed:@"icon-checkmark"]
                               withColor:[AppColorScheme white]] forState:UIControlStateNormal];
    return button;
}

- (void)handleRightButtonEvent:(id)sender
{
    if ([self.postTitleTextField.text isEqualToString:kEmptyString])
    {
        [Graphics alert:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Add some text!", @"")
                   type:ErrorAlert];
        return;
    }
    
    if ([self.pets count] == 0)
    {
        [Graphics alert:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"You don't have any pets!", @"")
                   type:ErrorAlert];
        return;
    }
    
    [self.postTitleTextField resignFirstResponder];
    [self.activity show];
    
    PFQueryService *service = [PFQueryService new];
    [service addPost:self
               image:[self imageByCroppingImage:self.image]
                text:self.postTitleTextField.text
             forUser:[ParseUser currentUser]
              forPet:[self.pets objectAtIndex:0]];
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
    }
    
    return YES;
}

#pragma mark - <PFQueryCallback>

- (void)onQueryListSuccess:(NSArray *)objects
{
    [self.pets addObjectsFromArray:objects];
    
    CGFloat offset = 0.0f;
    for (int i = 0; i < objects.count; i++)
    {
        ParsePet *pet = (ParsePet *)[objects objectAtIndex:i];
        CircleImageView *petImageView = [[CircleImageView alloc] initWithFrame:CGRectMake(offset, 0, 44, 44)];
        [petImageView setImage:[UIImage imageNamed:@"img-avatar"]];
        [self.scrollView addSubview:petImageView];
        [PFQueryService loadImageFile:pet.avatarImage imageView:petImageView completion:nil];
        offset += petImageView.bounds.size.width + 8.0f;
    }
    self.scrollView.contentSize = CGSizeMake(offset, self.scrollView.frame.size.height);
}

- (void)onPostSuccess
{
    [self.activity hide];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPostFailure
{
    [self.activity hide];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Can not post!", @"")
               type:ErrorAlert];
}

- (UIImage *)imageByCroppingImage:(UIImage *)image
{
    CGFloat width = image.size.width;
    CGFloat height = width * 9 / 16;
    CGSize size = CGSizeMake(width, height);
    
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}

@end