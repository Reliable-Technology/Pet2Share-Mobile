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
    [self setTableViewTheme];
    [self setTableViewCellTheme];
    [self setTabbarTheme];
}

+ (void)setNavigationBarTheme
{
    [[UINavigationBar appearance] setBarTintColor:[AppColor navigationBarBackgroundColor]];
    [[UINavigationBar appearance] setTintColor:[AppColor navigationBarTintColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont systemFontOfSize:16.0f weight:UIFontWeightBold]}];
}

+ (void)setTableViewTheme
{
    [UITableView appearance].sectionIndexColor = [AppColor tableViewHeaderForegroundColor];
    [UITableView appearance].sectionIndexBackgroundColor = [AppColor tableViewHeaderBackgroundColor];
    [UITableView appearance].backgroundColor = [AppColor tableViewBackgroundColor];
    [UITableView appearance].separatorColor = [AppColor tableViewSeparatorColor];
    [UITableView appearance].separatorInset = UIEdgeInsetsZero;
    [UITableView appearance].layoutMargins = UIEdgeInsetsZero;
    [UITableView appearance].separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [UITableView appearance].indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [UITableView appearance].tintColor = [AppColor tableViewTintColor];
    [UITableViewHeaderFooterView appearance].tintColor = [AppColor tableViewHeaderBackgroundColor];
}

+ (void)setTableViewCellTheme
{
    [UITableViewCell appearance].backgroundColor = [AppColor tableViewCellBackgroundColor];
    [UITableViewCell appearance].layoutMargins = UIEdgeInsetsZero;
}

+ (void)setTabbarTheme
{
//    [UITabBar appearance].backgroundColor = [AppColor tabBarBackgroundColor];
    [UITabBar appearance].barTintColor = [AppColor tabBarBackgroundColor];
    [UITabBar appearance].tintColor = [AppColor tabBarTintColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[AppColor tabBarTintColor]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[AppColor tabBarItemSelectedTitleColor]}
                                             forState:UIControlStateSelected];
}

@end
