//
//  AppColor.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppColorScheme.h"

@interface AppColor : NSObject

#pragma mark - UINavigationBar

+ (UIColor *)navigationBarBackgroundColor;
+ (UIColor *)navigationBarTintColor;
+ (UIColor *)navigationBarTextColor;
+ (UIColor *)navigationBarDisabledColor;
+ (UIColor *)navigationBarPageIndicatorColor;
+ (UIColor *)navigationBarPageHairLineColor;
+ (UIColor *)navigationBarSelectedMenuItemLabelColor;
+ (UIColor *)navigationBarUnselectedMenuItemLabelColor;

#pragma mark - UITableView

+ (UIColor *)tableViewBackgroundColor;
+ (UIColor *)tableViewHeaderBackgroundColor;
+ (UIColor *)tableViewHeaderForegroundColor;
+ (UIColor *)tableViewGroupedHeaderAndFooterForegroundColor;
+ (UIColor *)tableViewGroupedHeaderAndFooterBackgroundColor;
+ (UIColor *)tableViewTintColor;
+ (UIColor *)tableViewCellBackgroundColor;
+ (UIColor *)tableViewCellDetailsColor;
+ (UIColor *)tableViewSelectedCellBackgroundColor;
+ (UIColor *)tableViewSeparatorColor;
+ (UIColor *)tableViewEmptyCellBackgroundColor;
+ (UIColor *)tableViewSectionIndexColor;
+ (UIColor *)tableViewPrimaryColumnBackgroundColor;
+ (UIColor *)tableViewSectionIndexBackgroundColor;
+ (UIColor *)tableViewSectionIndexTrackingBackgroundColor;

#pragma mark - UILabel & UITextField

+ (UIColor *)textStyleTitleColor;
+ (UIColor *)textStyleTitleShadowColor;
+ (UIColor *)textStyleBodyColor;
+ (UIColor *)textStyleDescriptionColor;
+ (UIColor *)textStyleDisabledBodyColor;
+ (UIColor *)textStylePlaceholderColor;
+ (UIColor *)textStyleErrorColor;
+ (UIColor *)textStyleSuccessColor;
+ (UIColor *)textStyleLinkColor;
+ (UIColor *)textFieldTintColor;
+ (UIColor *)textViewBackgroundColor;

@end
