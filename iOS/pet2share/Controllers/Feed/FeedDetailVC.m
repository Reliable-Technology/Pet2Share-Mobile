//
//  FeedDetailVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "FeedDetailVC.h"
#import "FeedDetailTableVC.h"
#import "AppColor.h"

static NSString * const kLeftIconImageName = @"icon-arrowback";

@interface FeedDetailVC () <BaseNavigationProtocol>

@property (strong, nonatomic) FeedDetailTableVC *feedDetailTableVC;

@end

@implementation FeedDetailVC

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
       NSFontAttributeName:[UIFont systemFontOfSize:17.0f weight:UIFontWeightBold]}];
    self.title = [NSLocalizedString(@"Comments", @"") uppercaseString];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSeguePostDetailContainer])
    {
        self.feedDetailTableVC = (FeedDetailTableVC *)segue.destinationViewController;
        self.feedDetailTableVC.post = self.post;
    }
}

#pragma mark -
#pragma mark <BaseNavigationProtocol>

- (UIButton *)setupLeftBarButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight)];
    [backButton setImage:[UIImage imageNamed:kLeftIconImageName] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backButton;
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end