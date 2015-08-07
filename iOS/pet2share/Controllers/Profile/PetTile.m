//
//  PetTile.m
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PetTile.h"
#import "ParseServices.h"

static NSString * const kNibName = @"PetTile";

@interface PetTile ()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation PetTile

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [[NSBundle mainBundle] loadNibNamed:kNibName owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.view];
}

#pragma mark - Public Instance Methods

- (void)setUpView:(ParsePet *)pet
{
    self.nickNameLabel.text = pet.nickName ?: NSLocalizedString(@"N/A", @"");
    self.createdDateLabel.text = pet.createdAt ? pet.createdAt.description : NSLocalizedString(@"N/A", @"");
    [PFQueryService loadImageFile:pet.avatarImage imageView:self.avatarImageView completion:^(BOOL finished) {
        [self.activity stopAnimating];
    }];
}

@end
