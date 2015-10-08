//
//  PostCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PostCollectionCell.h"
#import "CircleImageView.h"
#import "Graphics.h"
#import "AppColor.h"
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
    CGFloat actualImageWidth = size.width-2*spacing;
    
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

- (void)setUpView
{
    // TODO: Implement later
}

@end
