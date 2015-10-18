//
//  FeedVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "FeedVC.h"
#import "Utils.h"
#import "AppColor.h"
#import "Graphics.h"
#import "Post.h"
#import "PostTextCell.h"
#import "CircleImageView.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "PostHeaderView.h"
#import "FeedDetailVC.h"

@interface FeedVC () <BaseNavigationProtocol, Pet2ShareServiceCallback, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _pageNumber;
    BOOL _hasAllData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation FeedVC

static NSString * const kCellIdentifier         = @"posttextcell";
static NSString * const kCellNibName            = @"PostTextCell";
static NSInteger const kNumberOfPostPerPage     = 10;
static CGFloat const kLoadingCellHeight         = 88.0f;

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.baseNavProtocol = self;
        _posts = [NSMutableArray array];
        _pageNumber = 0;
        _hasAllData = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup table view
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
    
    // Request data
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup navigation title
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSeguePostDetail]
        && [sender isKindOfClass:[Post class]])
    {
        FeedDetailVC *detailVC = (FeedDetailVC *)segue.destinationViewController;
        detailVC.post = (Post *)sender;
    }
}

- (void)dealloc
{
    TRACE_HERE;
    self.tableView = nil;
    self.posts = nil;
}

#pragma mark -
#pragma mark Private Instance Methods

- (void)requestData
{
    Pet2ShareService *service = [Pet2ShareService new];
    _pageNumber++;
    fTRACE(@"Page Number: %ld", (long)_pageNumber);
    [service getPostsByUser:self userId:[Pet2ShareUser current].identifier postCount:kNumberOfPostPerPage pageNumber:_pageNumber];
}

#pragma mark -
#pragma mark - <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    fTRACE(@"Number of Objects: %ld", objects.count);
    if (self.posts.count > 0 && objects.count == 0) _hasAllData = YES;
    [self.posts addObjectsFromArray:objects];
    [self.tableView reloadData];
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [Graphics alert:NSLocalizedString(@"Error", @"")
            message:errorMessage.message
               type:ErrorAlert];
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

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSection;
    
    if (self.posts.count == 0)
    {
        if (_hasAllData) numberOfSection = 0;
        else numberOfSection = 1;
    }
    else
    {
        if (_hasAllData)
            numberOfSection = self.posts.count;
        else
            numberOfSection = self.posts.count+1;
    }
    
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Post *post = self.posts[section];
    
    CGFloat width = tableView.bounds.size.width;

    PostHeaderView *headerView = [[PostHeaderView alloc] initWithFrame:CGRectMake(0, 0, width, [PostHeaderView height])];
    [headerView updateHeaderView:post.user.profilePictureUrl postedName:post.user.name postedDate:post.dateAdded];
    headerView.alpha = 0.95f;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_hasAllData) return [self postCell:indexPath];
    
    if (indexPath.section < self.posts.count)
        return [self postCell:indexPath];
    else
        return [self loadingCell];
}

- (UITableViewCell *)postCell:(NSIndexPath *)indexPath
{
    PostTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) cell = [[PostTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    
    @try
    {
        Post *post = self.posts[indexPath.section];
        [cell update:post.postDescription];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
    }
    return cell;
}

- (UITableViewCell *)loadingCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [AppColorScheme clear];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.center.x, cell.center.y);
    [cell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    cell.separatorInset = UIEdgeInsetsMake(0.f, self.view.frame.size.width, 0.f, 0.f);
    return cell;
}

#pragma mark -
#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.posts.count)
    {
        Post *post = self.posts[indexPath.section];
        return [PostTextCell cellHeightForText:post.postDescription];
    }
    else
    {
        return kLoadingCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < self.posts.count)
    {
        return [PostHeaderView height];
    }
    else
    {
        return 0.0f;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.section;
    fTRACE("Selected Index: %ld", (long)index);
    
    @try
    {
        Post *post = [self.posts objectAtIndex:index];
        [self performSegueWithIdentifier:kSeguePostDetail sender:post];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
    }
}

#pragma mark -
#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height))
    {
        [self requestData];
    }
}

@end