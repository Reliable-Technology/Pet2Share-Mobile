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

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postedDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postedImageView;

@end

@implementation PostCollectionCell

+ (CGFloat)cellHeight
{
    return 416.0f;
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
    // Poster username
    self.usernameLabel.text = post.poster.username;
    
    // Poster avatar image
    [PFQueryService loadImage:post.poster imageView:self.avatarImageView];
    
    // Post date
    self.postedDateLabel.text = [Utils formatDate:post.createdAt format:kFormatMonthYearShort zone:[NSTimeZone defaultTimeZone]];
    
    // Post image
    [PFQueryService loadImageFile:post.image imageView:self.postedImageView completion:nil];
}

@end
