//
//  FeedVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "FeedVC.h"
#import "AppColor.h"
#import "PostsVC.h"
#import "Graphics.h"

@interface FeedVC () <BaseNavigationProtocol>

@property (nonatomic, strong) PostsVC *postsCollectionView;

@end

@implementation FeedVC

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.baseNavProtocol = self;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    fTRACE(@"Segue Identifier: %@", segue.identifier);
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark -
#pragma mark <BaseNavigationProtocol>

- (UIButton *)setupRightBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight);
    [button setImage:[Graphics tintImage:[UIImage imageNamed:@"icon-compose"]
                               withColor:[AppColorScheme white]] forState:UIControlStateNormal];
    return button;
}

- (void)handleRightButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:kSegueNewPost sender:self];
}

@end