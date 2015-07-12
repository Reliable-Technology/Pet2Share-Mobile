//
//  RoundCornerButton.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundCornerButton : UIButton

@property (nonatomic, assign) BOOL isLoading;

+ (instancetype)button;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@end
