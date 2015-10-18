//
//  FeedDetailVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "FeedDetailVC.h"
#import "Post.h"
#import "Comment.h"
#import "AppColor.h"
#import "OrderedDictionary.h"
#import "PostDetailTextCell.h"
#import "CommentCell.h"

@interface FeedDetailVC () <BaseNavigationProtocol, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *cellData;

@end

@implementation FeedDetailVC

static NSString * const kPostDetailTextCellIdenfier     = @"postdetailtextcell";
static NSString * const kPostDetailTextCellNibName      = @"PostDetailTextCell";
static NSString * const kCommentCellIdentifier          = @"commentcell";
static NSString * const kCommentCellNibName             = @"CommentCell";
static NSString * const kLeftIconImageName              = @"icon-arrowback";
static NSString * const kCellReuseIdentifier            = @"cellIdentifier";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.baseNavProtocol = self;
        _cellData = [NSMutableArray array];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:kPostDetailTextCellNibName bundle:nil]
         forCellReuseIdentifier:kPostDetailTextCellIdenfier];
    [self.tableView registerNib:[UINib nibWithNibName:kCommentCellNibName bundle:nil]
         forCellReuseIdentifier:kCommentCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    [self initCellData];
}

#pragma mark - 
#pragma mark Private Instance Methods

- (void)initCellData
{
    @try
    {
        NSDictionary *profileCellDict = @{kCellClassName: kPostDetailTextCellNibName,
                                          kCellNameKey: self.post.user.name ?: kEmptyString,
                                          kCellImageLink: self.post.user.profilePictureUrl ?: kEmptyString,
                                          kCellDateKey: self.post.dateAdded ?: [NSNull class],
                                          kCellPostTextKey: self.post.postDescription,
                                          kCellReuseIdentifier: kPostDetailTextCellIdenfier};
        [self.cellData addObject:profileCellDict];
        
        for (Comment *comment in self.post.comments)
        {
            NSDictionary *profileCellDict = @{kCellClassName: kCommentCellNibName,
                                              kCellNameKey: comment.user.name ?: kEmptyString,
                                              kCellImageLink: comment.user.profilePictureUrl ?: kEmptyString,
                                              kCellDateKey: comment.dateAdded ?: [NSNull class],
                                              kCellCommentKey: comment.commentDescription,
                                              kCellReuseIdentifier: kCommentCellIdentifier};
            [self.cellData addObject:profileCellDict];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
    }
    
    [self.tableView reloadData];
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
    return [self.cellData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    UITableViewCell *cell;
    
    @try
    {
        NSDictionary *data = [self.cellData objectAtIndex:index];
        NSString *reuseIdentifier = data[kCellReuseIdentifier];
        Class cellClass = NSClassFromString(data[kCellClassName]);
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:reuseIdentifier];
        
        if ([reuseIdentifier isEqualToString:kPostDetailTextCellIdenfier])
        {
            [(PostDetailTextCell *)cell update:data[kCellImageLink]
                                    postedName:data[kCellNameKey]
                                    postedDate:data[kCellDateKey]
                                          text:data[kCellPostTextKey]];
        }
        else if ([reuseIdentifier isEqualToString:kCommentCellIdentifier])
        {
            [(CommentCell *)cell update:data[kCellImageLink]
                          commentedName:data[kCellNameKey]
                            commentText:data[kCellCommentKey]
                             postedDate:data[kCellDateKey]];
        }
        else
        {
            fTRACE(@"Error - Unrecognized Identifier %@", reuseIdentifier);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"cell"];
    }
    return cell;
}

#pragma mark -
#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.cellData[indexPath.row];
    if ([data[kCellReuseIdentifier] isEqualToString:kPostDetailTextCellIdenfier])
        return [PostDetailTextCell cellHeightForText:data[kCellPostTextKey]];
    else if ([data[kCellReuseIdentifier] isEqualToString:kCommentCellIdentifier])
        return [CommentCell cellHeightForText:data[kCellCommentKey]];
    return 0;
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

@end