//
//  ProfileCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 8/11/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ProfileCollectionCell.h"
#import "CircleImageView.h"
#import "AppColor.h"
#import "Graphics.h"
#import "ParseServices.h"

@interface ProfileCollectionCell () <PFQueryCallback, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *numberofPetsLabel;

@property (strong, nonatomic) NSMutableArray *pets;

@end

@implementation ProfileCollectionCell

+ (CGFloat)cellHeight
{
    return 136.0f;
}

- (void)awakeFromNib
{
    self.avatarImageView.borderColor = [UIColor whiteColor];
    self.avatarImageView.borderWidth = 3.0f;
    self.containerView.layer.masksToBounds = NO;
    self.containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.containerView.layer.shouldRasterize = YES;
    self.containerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.containerView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.containerView.layer.shadowRadius = 1.0f;
    self.containerView.layer.shadowOpacity = 0.85f;
    self.containerView.layer.cornerRadius = 5.0f;
    self.scrollView.delegate = self;
}

- (void)setupView:(ParseUser *)user
{
    // User name
    NSString *firstName = user.firstName ?: NSLocalizedString(@"First Name", @"");
    NSString *lastName = user.lastName ?: NSLocalizedString(@"Last Name", @"");
    self.nameLabel.text = [[NSString stringWithFormat:@"%@ %@", firstName, lastName] uppercaseString];
    
    // User avatar image
    self.avatarImageView.image = [UIImage imageNamed:@"img-avatar"];
    [PFQueryService loadImageFile:user.avatarImage imageView:self.avatarImageView completion:nil];
    
    if (!self.pets)
    {
        _pets = [NSMutableArray array];
        PFQueryService *service = [PFQueryService new];
        [service getPets:self forUser:[ParseUser currentUser]];
    }
    
}

#pragma mark - <PFQueryCallback>

- (void)onQueryListSuccess:(NSArray *)objects
{
    CGFloat offset = 0.0f;
    self.numberofPetsLabel.text = [NSString stringWithFormat:@"%ld %@", objects.count, NSLocalizedString(@"PETS", @"")];
    for (int i = 0; i < objects.count; i++)
    {
        ParsePet *pet = (ParsePet *)[objects objectAtIndex:i];
        CircleImageView *petImageView = [[CircleImageView alloc] initWithFrame:CGRectMake(offset, 0, 44, 44)];
        [petImageView setImage:[UIImage imageNamed:@"img-avatar"]];
        [self.scrollView addSubview:petImageView];
        [PFQueryService loadImageFile:pet.avatarImage imageView:petImageView completion:nil];
        offset += petImageView.bounds.size.width + 8.0f;
    }
    
    self.scrollView.contentSize = CGSizeMake(offset, self.scrollView.frame.size.height);
}

@end
