//
//  ProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileVC.h"
#import "CircleImageView.h"
#import "ParseServices.h"
#import "Graphics.h"
#import "PetTile.h"
#import "CommentCell.h"

static NSString * const kCellIdentifier     = @"commentcell";
static NSString * const kCellNibName        = @"CommentCell";

@interface ProfileVC () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register cell and remove the footer section
    [self.tableView registerNib:[UINib nibWithNibName:kCellNibName bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
    [self updateUserInfo:NO];
    [self setupScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Private Instance Methods

- (void)updateUserInfo:(BOOL)requireFetched
{
    ParseUser *currentUser = [ParseUser currentUser];
    
    // Title
    self.navigationItem.title = currentUser.username ?: NSLocalizedString(@"N/A", @"");

    // Labels
    __block NSString *firstName = nil;
    __block NSString *lastName = nil;

    // Name Label
    firstName = currentUser.firstName ?: NSLocalizedString(@"First Name", @"");
    lastName = currentUser.lastName ?: NSLocalizedString(@"Last Name", @"");
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    // Avatar image view
    [PFQueryService loadImageFile:currentUser.avatarImage imageView:self.avatarImageView];
    
    if (requireFetched)
    {
        // Fetch the current user from network for newer information
        [currentUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            ParseUser *user = (ParseUser *)object;
            if (user)
            {
                // Fetch name label
                firstName = user.firstName ?: NSLocalizedString(@"First Name", @"");
                lastName = user.lastName ?: NSLocalizedString(@"Last Name", @"");
                self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                
                // Fetch avatar image view
                [PFQueryService loadImage:currentUser imageView:self.avatarImageView];
            }
            else
            {
                fTRACE(@"Cannot fetch user profile, error: %@", error.localizedDescription);
            }
        }];
    }
}

- (void)setupScrollView
{
    CGFloat offset = 0.0f;
    for (int i = 0; i < 8; i++)
    {
        if (i == 0) offset += 16.0f;
        PetTile *tile = [[PetTile alloc] initWithFrame:CGRectMake(offset, 0, 200, 250)];
        [Graphics dropShadow:tile shadowOpacity:0.7f shadowRadius:3.0f offset:CGSizeZero];
        [self.scrollView addSubview:tile];
        offset += tile.bounds.size.width + 16.0f;
    }
    
    self.scrollView.contentSize = CGSizeMake(offset, self.scrollView.frame.size.height);
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    // TODO: Provide cell data
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Implement later
}

#pragma mark - <UIScrollViewDelegate>

@end
