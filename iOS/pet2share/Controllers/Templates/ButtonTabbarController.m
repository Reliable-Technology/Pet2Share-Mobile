//
//  ButtonTabbarController.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <DBCamera/DBCameraContainerViewController.h>
#import "ButtonTabbarController.h"
#import "CameraNavigationController.h"
#import "PostImageVC.h"

static NSString * const kCameraImage            = @"img-camera";
static NSInteger const kTabBarCameraItemTag     = 1;

@interface ButtonTabbarController () <DBCameraViewControllerDelegate>
{
    BOOL _cameraButtonTapped;
}

@property (nonatomic, strong) UIImage *image;

@end

@implementation ButtonTabbarController

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _cameraButtonTapped = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add center button
    [self addCenterButtonWithImage:[UIImage imageNamed:kCameraImage]
                    highlightImage:[UIImage imageNamed:kCameraImage]];
    
    [[[self.tabBar items] objectAtIndex:kTabBarCameraItemTag] setEnabled:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSeguePostImage])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        PostImageVC *postImageVC = (PostImageVC *)navController.topViewController;
        if (postImageVC) postImageVC.image = self.image;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_cameraButtonTapped)
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark -
#pragma mark Private Instance Methods

/*!
 *  @method addCenterButtonWithImage:highlightImage:
 *
 *  @param buttonImage      The original image
 *  @param highlightImage   The highlighted image
 *
 *  @discussion     Setup a button in a the middle of the tabbar
 */
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin
    |UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0f, 0.0f, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDiff = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDiff < 0)
    {
        button.center = self.tabBar.center;
    }
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDiff/2.0f;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

- (void)buttonTapped:(id)sender
{
    fTRACE(@"Sender: %@", sender);
    
    _cameraButtonTapped = YES;
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    CameraNavigationController *nav = [[CameraNavigationController alloc] initWithRootViewController:cameraContainer];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark <DBCameraViewControllerDelegate>

- (void)dismissCamera:(id)cameraViewController
{
    _cameraButtonTapped = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    _cameraButtonTapped = NO;
    self.image = image;
    [cameraViewController restoreFullScreenMode];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:kSeguePostImage sender:nil];
    }];
}

@end