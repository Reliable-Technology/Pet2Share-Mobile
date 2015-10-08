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

+ (UIColor *)navigationBarBackgroundColor SCHEME(darkBlueColor)
+ (UIColor *)navigationBarTintColor SCHEME(white)
+ (UIColor *)navigationBarTextColor SCHEME(white)
+ (UIColor *)navigationBarDisabledColor SCHEME(lightGray)
+ (UIColor *)navigationBarPageIndicatorColor SCHEME(white)
+ (UIColor *)navigationBarPageHairLineColor SCHEME(darkGray)
+ (UIColor *)navigationBarSelectedMenuItemLabelColor SCHEME(white);
+ (UIColor *)navigationBarUnselectedMenuItemLabelColor SCHEME(lightGray);

#pragma mark - UITableView

+ (UIColor *)tableViewBackgroundColor SCHEME(white)
+ (UIColor *)tableViewHeaderBackgroundColor SCHEME(green)
+ (UIColor *)tableViewHeaderForegroundColor SCHEME(white)
+ (UIColor *)tableViewTintColor SCHEME(blue)
+ (UIColor *)tableViewGroupedHeaderAndFooterForegroundColor SCHEME(green)
+ (UIColor *)tableViewGroupedHeaderAndFooterBackgroundColor SCHEME(silver)
+ (UIColor *)tableViewCellBackgroundColor SCHEME(clear)
+ (UIColor *)tableViewCellDetailsColor SCHEME(lightGray)
+ (UIColor *)tableViewPrimaryColumnBackgroundColor SCHEME(silver)
+ (UIColor *)tableViewSelectedCellBackgroundColor
{
    CGFloat r, g, b, a;
    [[AppColorScheme darkGray] getRed: &r green: &g blue: &b alpha: &a];
    return [UIColor colorWithRed: r green: g blue: b alpha: 0.4];
}
+ (UIColor *)tableViewSeparatorColor SCHEME(lightGray)
+ (UIColor *)tableViewEmptyCellBackgroundColor SCHEME(silver)
+ (UIColor *)tableViewSectionIndexColor SCHEME(darkGray)
+ (UIColor *)tableViewSectionIndexBackgroundColor SCHEME(clear)
+ (UIColor *)tableViewSectionIndexTrackingBackgroundColor SCHEME(lightGray)

#pragma mark - UITabbar

+ (UIColor *)tabBarBackgroundColor SCHEME(white)
+ (UIColor *)tabBarTintColor SCHEME(darkGray)
+ (UIColor *)tabBarItemSelectedTitleColor SCHEME(darkBlueColor)

#pragma mark - UILabel & UITextField

+ (UIColor *)textStyleTitleColor SCHEME(darkGray)
+ (UIColor *)textStyleTitleShadowColor SCHEME(white)
+ (UIColor *)textStyleBodyColor SCHEME(darkGray)
+ (UIColor *)textStyleDescriptionColor SCHEME(lightGray)
+ (UIColor *)textStyleDisabledBodyColor SCHEME(lightGray)
+ (UIColor *)textStylePlaceholderColor SCHEME(lightGray)
+ (UIColor *)textStyleErrorColor SCHEME(red);
+ (UIColor *)textStyleSuccessColor SCHEME(green)
+ (UIColor *)textStyleLinkColor SCHEME(blue)
+ (UIColor *)textFieldTintColor SCHEME(black)
+ (UIColor *)textViewBackgroundColor SCHEME(clear)

@end
