//
//  Graphics.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Graphics : NSObject

#pragma mark - Color

+ (UIColor *)lighterColorForColor:(UIColor *)color;
+ (UIColor *)darkerColorForColor:(UIColor *)color;

@end
