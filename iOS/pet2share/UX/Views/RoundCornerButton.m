//
//  RoundCornerButton.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "RoundCornerButton.h"
#import "Graphics.h"

@interface RoundCornerButton ()

@property (nonatomic, readonly) UIActivityIndicatorView *activity;

@end

@implementation RoundCornerButton

@synthesize activity = _activity;

+ (instancetype)button
{
    return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Private Instance Methods

- (void)setup
{
    // Corner Radius
    self.layer.cornerRadius = 3.f;
    self.clipsToBounds = YES;
    self.activityPosition = RightSide;
    _isLoading = NO;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity)
    {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        CGFloat height = self.bounds.size.height / 2;
        CGFloat width;
        
        switch (self.activityPosition)
        {
            case RightSide:
                width = self.bounds.size.width;
                self.activity.center = CGPointMake(width - height , height);
                break;
            case Center:
                width = self.bounds.size.width/2;
                self.activity.center = CGPointMake(width , height);
                break;
                
            default:
                break;
        }

        [self addSubview:self.activity];
    }
    return _activity;
}

#pragma mark - Public Instance Methods

- (void)showActivityIndicator
{
    self.enabled = NO;
    self.isLoading = YES;
    
    if (self.activityPosition == Center)
        self.titleLabel.layer.opacity = 0.0f;
    [self.activity startAnimating];
}

- (void)hideActivityIndicator
{
    self.enabled = YES;
    self.isLoading = NO;
    if (self.activityPosition == Center)
        self.titleLabel.layer.opacity = 1.0f;
    [self.activity stopAnimating];
}

@end