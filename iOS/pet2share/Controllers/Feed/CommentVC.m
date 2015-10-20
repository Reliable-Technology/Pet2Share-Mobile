//
//  CommentVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CommentVC.h"
#import "Graphics.h"
#import "AppColor.h"
#import "CommentCollectionVC.h"

@interface CommentVC () <BaseNavigationProtocol>

@end

@implementation CommentVC

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
       NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightBold]}];
    self.title = [NSLocalizedString(@"Comments", @"") uppercaseString];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueCommentContainer])
    {
        CommentCollectionVC *commentCollection = (CommentCollectionVC *)segue.destinationViewController;
        commentCollection.post = self.post;
    }
}

#pragma mark -
#pragma mark <BaseNavigationProtocol>

- (UIButton *)setupLeftBarButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight)];
    [backButton setImage:[UIImage imageNamed:@"icon-arrowback"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return backButton;
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end