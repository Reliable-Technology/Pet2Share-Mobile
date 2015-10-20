//
//  ActivityView.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ActivityView.h"

@interface ActivityView ()
{
    CGFloat _xOffset;
    CGFloat _yOffset;
    BOOL _needReset;
}

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation ActivityView

static const CGFloat kActivityViewSize = 22.0f;

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _xOffset = 0.0f;
        _yOffset = 0.0f;
        _needReset = NO;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.bounds = CGRectMake(0.0f, 0.0f, kActivityViewSize, kActivityViewSize);
        [self setFlexibleMarginsForView:self.activityIndicator];
        [self setFlexibleMarginsForView:self];
        [self addSubview:self.activityIndicator];
        
        parentView = [(UIView *)self superview];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [self initWithView:view xOffset:0 yOffset:0];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset
{
    self = [super initWithFrame:[self createFrame:view xOffset:xOffset yOffset:yOffset]];
    if (self)
    {
        _xOffset = xOffset;
        _yOffset = yOffset;
        _needReset = YES;
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.bounds = CGRectMake(0.0f, 0.0f, kActivityViewSize, kActivityViewSize);
        [self setFlexibleMarginsForView:self.activityIndicator];
        [self setFlexibleMarginsForView:self];
        [self addSubview:self.activityIndicator];
        
        parentView = view;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!parentView) parentView = newSuperview;
}

- (void)setFlexibleMarginsForView: (UIView*) view
{
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
}

#pragma mark - Private Instance Methods

- (CGRect)createFrame:(UIView*)parent
{
    return [self createFrame:parent xOffset:_xOffset yOffset:_yOffset];
}

- (CGRect)createFrame:(UIView *)parent xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset
{
    return [self centerFrame:CGRectMake(0, 0, kActivityViewSize, kActivityViewSize)
                     inFrame:parent.frame
                     xOffset:xOffset
                     yOffset:yOffset];
}

- (CGRect)centerFrame:(CGRect)innerFrame
              inFrame:(CGRect)outerFrame
              xOffset:(CGFloat)xOffset
              yOffset:(CGFloat)yOffset
{
    return CGRectMake((outerFrame.size.width - innerFrame.size.width) / 2 + xOffset,
                      (outerFrame.size.height - innerFrame.size.height) / 2 + yOffset,
                      innerFrame.size.width,
                      innerFrame.size.height);
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [self resetPosition];
}

#pragma mark - Public Instance Methods

- (void)show
{
    if (parentView) [parentView addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

- (void)resetPosition
{
    if (_needReset) self.frame = [self createFrame:parentView];
}

- (void)setFullScreen
{
    CGRect parentFrame = parentView.frame;
    self.frame = parentFrame;
    
    self.activityIndicator.frame = [self centerFrame:self.activityIndicator.frame
                                             inFrame:parentFrame
                                             xOffset:0
                                             yOffset:0];
    
    self.layer.opacity = 0.5;
    self.layer.cornerRadius = parentView.layer.cornerRadius;
}

@end
