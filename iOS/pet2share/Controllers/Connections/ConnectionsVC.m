//
//  ConnectionsVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ConnectionsVC.h"
#import "ProfileCell.h"
#import "AppColor.h"
#import "ActivityView.h"
#import "ParseServices.h"
#import "Graphics.h"

static NSString * const kCellIdentifier     = @"profilecell";
static NSString * const kCellNibName        = @"ProfileCell";

@interface ConnectionsVC () <PFQueryCallback, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ActivityView *activity;

@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation ConnectionsVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _users = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Title
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
    
    // Setup activity bounds
    _activity = [[ActivityView alloc] initWithView:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Request Data
    [self requestData];
}

#pragma mark - Parse Services

- (void)requestData
{
    // Show activity when there are no items;
    if ([self.users count] == 0)
    {
        [self.activity show];
    }
    
    // Remove all current users (if any)
    [self.users removeAllObjects];
    
    PFQueryService *service = [PFQueryService new];
    [service getConnections:self forUser:[ParseUser currentUser]];
}

- (void)onQueryListSuccess:(NSArray *)objects
{
    [self.activity hide];
    [self.users addObjectsFromArray:objects];
    [self.tableView reloadData];
}

- (void)onQueryError:(NSError *)error
{
    [self.activity hide];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:error.description type:ErrorAlert];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    
    @try
    {
        ParseUser *user = [self.users objectAtIndex:indexPath.row];
        [cell setupView:user];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: Exception: %@", __func__, exception.description);
    }

    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProfileCell cellHeight];
}

@end