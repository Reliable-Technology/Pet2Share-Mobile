//
//  PetCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 8/8/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PetCollectionCell.h"
#import "ParseServices.h"
#import "Utils.h"
#import "Graphics.h"

@interface PetCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end

@implementation PetCollectionCell

#pragma mark - Life Cycle

+ (CGFloat)cellHeight
{
    return 250.0f;
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

- (void)setUpView:(ParsePet *)pet
{
    // Name
    self.nickNameLabel.text = pet.nickName ?: NSLocalizedString(@"N/A", @"");
    
    // Join (or created date)
    NSString *createdDate = [Utils formatDate:pet.createdAt format:kFormatMonthYearShort zone:[NSTimeZone defaultTimeZone]];
    self.createdDateLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Joined", @""), createdDate];
    
    // Avatar Image
    self.avatarImageView.image = [UIImage imageNamed:@"img-placeholder"];
    [PFQueryService loadImageFile:pet.avatarImage imageView:self.avatarImageView completion:^(BOOL finished) {
    }];
}


@end
