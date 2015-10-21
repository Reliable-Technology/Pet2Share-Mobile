//
//  EmptyDataView.h
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyDataView : UIView

+ (CGFloat)height;
+ (CGFloat)width;

- (void)show;
- (void)hide;
- (void)updateViewWithFirstText:(NSString *)firstText secondText:(NSString *)secondText iconImageName:(NSString *)iconImageName;

@end
