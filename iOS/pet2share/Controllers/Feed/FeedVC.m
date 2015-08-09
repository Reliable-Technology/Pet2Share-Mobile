//
//  FeedVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "FeedVC.h"
#import "AppColor.h"
#import "Graphics.h"
#import "ParseServices.h"

static NSString * const kImageIconName  = @"icon-profile";

@interface FeedVC () <BarButtonsProtocol>
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
    if ([segue.identifier isEqualToString:kSegueProfile])
    {
        UIViewController *controller = segue.destinationViewController;
        controller.transitioningDelegate = self.transitionManager;
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

- (void)handleLeftButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:kSegueProfile sender:self];
}

@end