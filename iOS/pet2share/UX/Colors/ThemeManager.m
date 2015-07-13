//
//  ThemeManager.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ThemeManager.h"
#import "Graphics.h"
#import "AppColor.h"

@implementation ThemeManager

+ (void)setDefaultTheme
{
    [self setNavigationBarTheme];
}

+ (void)setNavigationBarTheme
{
    [UINavigationBar appearance].barTintColor = [Graphics darkerColorForColor:[AppColor navigationBarBackgroundColor]];
    [UINavigationBar appearance].tintColor = [AppColor navigationBarTintColor];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].barStyle = UIBarStyleBlackOpaque;
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kDefaultBoldTypeface size:18.0f]}];
}

@end
