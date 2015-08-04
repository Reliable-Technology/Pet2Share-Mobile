//
//  CircleImageView.h
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleImageView : UIImageView

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) float cornerRadius;

- (id)initWithFrame:(CGRect)frame borderColor:(UIColor*)borderColor borderWidth:(float)borderWidth;
- (id)initWithImage:(UIImage *)image borderColor:(UIColor*)borderColor borderWidth:(float)borderWidth;
- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage borderColor:(UIColor*)borderColor borderWidth:(float)borderWidth;

@end