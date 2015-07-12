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
    
    _isLoading = NO;
}

- (UIActivityIndicatorView *)activity
{
    if (!_activity)
    {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGFloat height = self.bounds.size.height / 2;
        CGFloat width = self.bounds.size.width;
        self.activity.center = CGPointMake(width - height , height);
        [self addSubview:self.activity];
    }
    return _activity;
}

#pragma mark - Public Instance Methods

- (void)showActivityIndicator
{
    self.backgroundColor = [Graphics darkerColorForColor:self.backgroundColor];
    self.enabled = NO;
    self.isLoading = YES;
    [self.activity startAnimating];
}

- (void)hideActivityIndicator
{
    self.backgroundColor = [Graphics lighterColorForColor:self.backgroundColor];
    self.enabled = YES;
    self.isLoading = NO;
    [self.activity stopAnimating];
}

@end