//
//  AppColor.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "AppColor.h"
#import "AppColorScheme.h"

@implementation AppColor

#define SCHEME(name) { return [AppColorScheme name]; }

#pragma mark - UINavigationBar

+ (UIColor *)navigationBarBackgroundColor SCHEME(purple)
+ (UIColor *)navigationBarTintColor SCHEME(white)
+ (UIColor *)navigationBarTextColor SCHEME(white)
+ (UIColor *)navigationBarDisabledColor SCHEME(lightGray)
+ (UIColor *)navigationBarPageIndicatorColor SCHEME(white)
+ (UIColor *)navigationBarPageHairLineColor SCHEME(darkGray)
+ (UIColor *)navigationBarSelectedMenuItemLabelColor SCHEME(white);
+ (UIColor *)navigationBarUnselectedMenuItemLabelColor SCHEME(lightGray);

@end
