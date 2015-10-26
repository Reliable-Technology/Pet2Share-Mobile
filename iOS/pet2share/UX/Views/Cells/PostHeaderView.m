//
//  PostHeaderView.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PostHeaderView.h"
#import "CircleImageView.h"
#import "Pet2ShareService.h"
#import "Utils.h"

@interface PostHeaderView ()

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *view;
- (IBAction)headerDidTapped:(id)sender;

@end

@implementation PostHeaderView

+ (CGFloat)height
{
    return 68.0f;
}

#pragma mark -
#pragma mark Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initView];
    }
    return self;
}

- (void)initView
{
    [[NSBundle mainBundle] loadNibNamed:@"PostHeaderView" owner:self options:nil];
    [self addSubview:self.view];
}

#pragma mark -
#pragma mark Public Instance Methods

- (void)updateHeaderView:(NSString *)imageUrl postedName:(NSString *)postedName postedDate:(NSDate *)postedDate
{
    Pet2ShareService *service = [Pet2ShareService new];
    self.avatarImageView.image = [UIImage imageNamed:@"img-avatar"];
    [service loadImage:imageUrl aspectRatio:Square completion:^(UIImage *image) {
        self.avatarImageView.image = image ?: [UIImage imageNamed:@"img-avatar"];
    }];
    
    self.nameLabel.text = postedName;
    self.dateLabel.text = [Utils formatNSDateToString:postedDate];
}

- (IBAction)headerDidTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(performActionOnTap:)])
        [self.delegate performActionOnTap:self];
}

@end
