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

@interface ProfileVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
    __block NSString *city = nil;
    __block NSString *state = nil;
    
    // Name Label
    firstName = currentUser.firstName ?: NSLocalizedString(@"First Name", @"");
    lastName = currentUser.lastName ?: NSLocalizedString(@"Last Name", @"");
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    // Location Label
    city = currentUser.city ?: kEmptyString;
    state = currentUser.regionState ?: kEmptyString;
    if (city.length > 0 && state.length > 0)
        self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
    
    // Avatar image view
    [PFQueryService loadImageFile:currentUser.coverImage imageView:self.coverImageView];
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
                
                // Location Label
                city = currentUser.city ?: kEmptyString;
                state = currentUser.regionState ?: kEmptyString;
                if (city.length > 0 && state.length > 0)
                    self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
                
                // Fetch avatar image view
                [PFQueryService loadImageFile:currentUser.coverImage imageView:self.coverImageView];
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
    CGFloat offset = 0;
    for (int i = 0; i < 8; i++)
    {
        if (i == 0) offset += 20;
        PetTile *tile = [[PetTile alloc] initWithFrame:CGRectMake(offset, 0, 200, 250)];
        [Graphics roundView:tile cornerRadius:10.0f shadowOpacity:0.7f shadowRadius:3.0f offset:CGSizeZero];
        [self.scrollView addSubview:tile];
        offset += tile.bounds.size.width + 20;
    }
    
    self.scrollView.contentSize = CGSizeMake(offset, self.scrollView.frame.size.height);
}

#pragma mark - <UIScrollViewDelegate>

@end
