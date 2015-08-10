//
//  FeedVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <DBCamera/DBCameraContainerViewController.h>
#import "CameraNavigationController.h"
#import "FeedVC.h"
#import "ImagePostVC.h"
#import "AppColor.h"
#import "Graphics.h"
#import "ParseServices.h"

static NSString * const kImageIconName          = @"icon-profile";
static NSString * const kImageCameraIconName    = @"icon-camera";

@interface FeedVC () <BarButtonsProtocol, DBCameraViewControllerDelegate>
{
    CGRect _profileImgFrame;
}

@property (nonatomic, strong) TransitionManager *transitionManager;

@end

@implementation FeedVC

static NSString * const kCellIdentifier = @"cellidentifier";
static NSString * const kCellNibName    = @"DashboardCollectionCell";

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
        _transitionManager = [TransitionManager new];
        _profileImgFrame = CGRectMake(0.0f, 0.0f, kBarButtonWidth, kBarButtonHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try
    {
        if ([segue.identifier isEqualToString:kSegueProfile])
        {
            UIViewController *controller = segue.destinationViewController;
            controller.transitioningDelegate = self.transitionManager;
        }
        else if ([segue.identifier isEqualToString:kSegueImagePost] && [sender isKindOfClass:[UIImage class]])
        {
            UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
            navController.transitioningDelegate = self.transitionManager;
            ImagePostVC *controller = (ImagePostVC *)navController.topViewController;
            controller.image = (UIImage *)sender;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark - <BarButtonsProtocol>

- (UIButton *)setupLeftBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = _profileImgFrame;
    [button setBackgroundImage:[Graphics tintImage:[UIImage imageNamed:kImageIconName]
                                         withColor:[AppColorScheme white]]
                      forState:UIControlStateNormal];
    
    [PFQueryService loadImage:[ParseUser currentUser] completion:^(UIImage *image) {
        [self setLeftBarButtonImage:[Graphics circleImage:image frame:_profileImgFrame]];
    }];
    
    return button;
}

- (UIButton *)setupRightBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0.0f, 0.0f, 24.0f, 18.0f);
    [button setBackgroundImage:[Graphics tintImage:[UIImage imageNamed:kImageCameraIconName]
                                         withColor:[AppColorScheme white]]
                      forState:UIControlStateNormal];
    return button;
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:kSegueProfile sender:self];
}

- (void)handleRightButtonEvent:(id)sender
{
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    CameraNavigationController *nav = [[CameraNavigationController alloc] initWithRootViewController:cameraContainer];
    nav.transitioningDelegate = self.transitionManager;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - <DBCameraViewControllerDelegate>

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:kSegueImagePost sender:image];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [cameraViewController restoreFullScreenMode];
}

- (void)dismissCamera:(id)cameraViewController
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [cameraViewController restoreFullScreenMode];
}

@end