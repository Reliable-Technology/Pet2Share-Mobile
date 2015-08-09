//
//  PostCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PostCollectionCell.h"
#import "CircleImageView.h"
#import "Graphics.h"
#import "AppColor.h"
#import "ParseServices.h"
#import "Utils.h"

@interface PostCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *postedTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postedImageView;

@end

@implementation PostCollectionCell

+ (CGFloat)cellHeight:(CGFloat)spacing
{
    CGSize size = [Graphics getDeviceSize];
    
    // Consult xib for this value
    CGFloat headerHeight = 80.0f;
    
    // Get the actual width, we assume this is for one column
    // layout.
    CGFloat actualImageWidth = size.width- 2*spacing;
    
    // The picture at the bottom is changed due to device
    // We want to have 16:9 aspect ratio.
    CGFloat actualImageHeight = ceilf(actualImageWidth*9/16);
    
    // Actual cell height is the sum of header with image height
    CGFloat actualHeight = headerHeight+actualImageHeight;
    
    return actualHeight;
}

- (void)awakeFromNib
{    
    self.layer.masksToBounds = NO;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.85f;
}

#pragma mark - Public Instance Methods

- (void)setUpView:(ParsePost *)post
{
    // Poster name
    NSString *firstName = post.poster.firstName ?: NSLocalizedString(@"First Name", @"");
    NSString *lastName = post.poster.lastName ?: NSLocalizedString(@"Last Name", @"");
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    // Poster avatar image
    [PFQueryService loadImage:post.poster imageView:self.avatarImageView];
    
    // Post date
    self.postedDateLabel.text = [Utils formatDate:post.createdAt format:kFormatMonthYearShort zone:[NSTimeZone defaultTimeZone]];
    
    // Post Title
    self.postedTitleLabel.text = post.title;
    
    // Post image
    [PFQueryService loadImageFile:post.image imageView:self.postedImageView completion:nil];
    
}

@end
