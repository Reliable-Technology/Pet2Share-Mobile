//
//  ActivityView.h
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityView : UIView
{
    __weak UIView *parentView;
}

- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view xOffset:(CGFloat)xOffset yOffset:(CGFloat)yOffset;
- (void)show;
- (void)hide;
- (void)resetPosition;
- (void)setFullScreen;

@end
