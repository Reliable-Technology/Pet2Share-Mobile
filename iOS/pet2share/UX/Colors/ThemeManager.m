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

@end
