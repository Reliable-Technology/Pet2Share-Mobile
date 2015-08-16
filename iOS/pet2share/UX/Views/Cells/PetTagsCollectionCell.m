//
//  PetTagsCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 8/16/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PetTagsCollectionCell.h"
#import "CircleImageView.h"
#import "CheckMark.h"
#import "ParseServices.h"

@interface PetTagsCollectionCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet CheckMark *checkMark;

@end

@implementation PetTagsCollectionCell

+ (CGFloat)cellHeight
{
    return 56.0f;
}

- (void)awakeFromNib
{
    self.alpha = 0.7f;
    self.layer.masksToBounds = NO;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    self.layer.cornerRadius = 3.0f;
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.85f;
}

#pragma mark - Public Instance Methods

- (void)setupView:(ParsePet *)pet
{
    // Name
    self.petNameLabel.text = pet.nickName ?: NSLocalizedString(@"N/A", @"");
    
    // Avatar Image
    self.avatarImageView.image = [UIImage imageNamed:@"img-avatar"];
    [PFQueryService loadImageFile:pet.avatarImage imageView:self.avatarImageView completion:nil];
}

@end
