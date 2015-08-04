//
//  CircleImageView.m
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "CircleImageView.h"

@interface CircleImageView ()

- (void)draw;

@end

@implementation CircleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _cornerRadius = self.frame.size.height/2.0f;
        [self draw];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _borderWidth = 0.0f;
        _cornerRadius = self.frame.size.height/2.0f;
        [self draw];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame borderColor:(UIColor*)borderColor borderWidth:(float)borderWidth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _borderColor = borderColor;
        _borderWidth = borderWidth;
        _cornerRadius = self.frame.size.height/2.0f;
        [self draw];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image borderColor:(UIColor*)borderColor borderWidth:(float)borderWidth
{
    self = [super initWithImage:image];
    if (self)
    {
        _borderColor = borderColor;
        _borderWidth = borderWidth;
        _cornerRadius = self.frame.size.height/2.0f;
        [self draw];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage borderColor:(UIColor*)borderColor borderWidth:(float)borderWidth
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self)
    {
        _borderColor = borderColor;
        _borderWidth = borderWidth;
        _cornerRadius = self.frame.size.height/2.0f;
        [self draw];
    }
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self draw];
}

- (void)setBorderWidth:(float)borderWidth
{
    _borderWidth = borderWidth;
    [self draw];
}

- (void)setCornerRadius:(float)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self draw];
}

- (void)draw
{
    CGRect frame = self.frame;
    if (frame.size.width != frame.size.height)
    {
        NSLog(@"Warning: Height and Width should be the same for image view");
    }
    CALayer *l = [self layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:_cornerRadius];
    
    if (_borderWidth < 0)
    {
        [l setBorderWidth:3.0];
    }
    else
    {
        [l setBorderWidth:_borderWidth];
    }
    
    if (_borderColor == nil)
    {
        [l setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    else
    {
        [l setBorderColor:[_borderColor CGColor]];
    }
}

@end