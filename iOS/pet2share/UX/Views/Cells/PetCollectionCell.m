//
//  PetCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PetCollectionCell.h"
#import "Utils.h"
#import "Graphics.h"
#import "Pet2ShareUser.h"
#import "Pet2ShareService.h"

@interface PetCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherInfoLabel;

@end

@implementation PetCollectionCell

+ (CGFloat)cellHeight:(CGFloat)spacing
{
    CGSize size = [Graphics getDeviceSize];
    
    // Consult xib for this value
    CGFloat footerHeight = 50.0f;
    
    // Get the actual width, we assume this is for two columns
    // layout.
    CGFloat actualImageWidth = size.width-3*spacing;
    
    // The picture at the bottom is changed due to device
    // We want to have 1:1 aspect ratio.
    CGFloat actualImageHeight = ceilf(actualImageWidth/2);
    
    // Actual cell height is the sum of header with image height
    CGFloat actualHeight = actualImageHeight+footerHeight;
    
    return actualHeight;
}

- (void)awakeFromNib
{
    [Graphics dropShadow:self shadowOpacity:0.85f shadowRadius:1.0f offset:CGSizeZero];
}

#pragma mark - Public Instance Methods

- (void)setupView:(Pet *)pet
{
    fTRACE(@"Pet: %@", pet);
    
    // Pet name
    self.nameLabel.text = pet.name;
    
    // Other Info
    self.otherInfoLabel.text = pet.about;
    
    // Load Image
    self.profileImageView.image = [UIImage new];
    Pet2ShareService *service = [Pet2ShareService new];
    [service loadImage:pet.profilePicture completion:^(UIImage *image) {
        if (!image) image = [UIImage new];
        self.profileImageView.image = image;
    }];
}

@end
