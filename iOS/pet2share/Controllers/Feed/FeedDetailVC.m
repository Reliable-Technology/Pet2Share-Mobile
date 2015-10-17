//
//  FeedDetailVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "FeedDetailVC.h"
#import "PostTextCell.h"
#import "Post.h"
#import "AppColor.h"

@interface FeedDetailVC () <BaseNavigationProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FeedDetailVC

static NSString * const kPostCellIdentifier     = @"posttextcell";
static NSString * const kPostCellNibName        = @"PostTextCell";
static NSString * const kCommentCellIdentifier  = @"commentcell";
static NSString * const kCommentCellNibName     = @"CommentCell";
static NSString * const kLeftIconImageName      = @"icon-arrowback";

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

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

#pragma mark -
#pragma mark <UITableViewDelegate>

@end