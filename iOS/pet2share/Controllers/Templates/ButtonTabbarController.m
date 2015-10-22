//
//  ButtonTabbarController.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ButtonTabbarController.h"
#import "Graphics.h"
#import "NewPostVC.h"

static NSString * const kCameraImage            = @"img-camera";
static NSInteger const kTabBarCameraItemTag     = 1;

@interface ButtonTabbarController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) TransitionZoom *transitionZoom;

@end

@implementation ButtonTabbarController

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _transitionZoom = [TransitionZoom new];
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
    if ([segue.identifier isEqualToString:kSegueNewPost])
    {
        NewPostVC *newPostVC = (NewPostVC *)segue.destinationViewController;
        newPostVC.transitioningDelegate = self.transitionZoom;
        newPostVC.postImage = self.capturedImage;
    }
}

- (void)dealloc
{
    TRACE_HERE;
    self.capturedImage = nil;
    self.transitionZoom = nil;
}

#pragma mark - Private Instance Methods

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
    
    @try
    {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.transitioningDelegate = self.transitionZoom;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Camera is not available", @"")
                   type:ErrorAlert];
    }
}

#pragma mark - <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    fTRACE("Info: %@", info);
    
    /** Info Example
     * UIImagePickerControllerCropRect = "NSRect: {{0, 0}, {2668, 1772}}";
     * UIImagePickerControllerEditedImage = "<UIImage: 0x7fa49f896350> size {748, 496} orientation 0 scale 1.000000";
     * UIImagePickerControllerMediaType = "public.image";
     * UIImagePickerControllerOriginalImage = "<UIImage: 0x7fa49f895ec0> size {2668, 1772} orientation 0 scale 1.000000";
     * UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=D77460CE-4855-4A54-BE4D-5C0A84C7742B&ext=JPG";
     */
    
    self.capturedImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:kSegueNewPost sender:self];
}

@end