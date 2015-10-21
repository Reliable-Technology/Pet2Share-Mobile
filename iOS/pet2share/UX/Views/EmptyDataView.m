//
//  EmptyDataView.m
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "EmptyDataView.h"

@interface EmptyDataView ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet SpringView *view;

@end

@implementation EmptyDataView

+ (CGFloat)height
{
    return 134.0f;
}

+ (CGFloat)width
{
    return 200.0f;
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
    [[NSBundle mainBundle] loadNibNamed:@"EmptyDataView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.hidden = YES;
}

- (void)show
{
    self.view.hidden = NO;
    self.view.animation = @"zoomIn";
    self.view.curve = @"spring";
    self.view.duration = 1.0f;
    [self.view animate];
}

- (void)hide
{
    self.view.hidden = YES;
    self.view.animation = @"zoomOut";
    self.view.curve = @"easeInOut";
    self.view.duration = 1.0f;
    [self.view animate];
}

- (void)updateViewWithFirstText:(NSString *)firstText secondText:(NSString *)secondText iconImageName:(NSString *)iconImageName
{
    self.firstLabel.text = firstText;
    self.secondLabel.text = secondText;
    self.iconImageView.image = [UIImage imageNamed:iconImageName];
}

@end
