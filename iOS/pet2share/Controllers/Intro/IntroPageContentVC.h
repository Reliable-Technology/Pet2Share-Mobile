//
//  IntroPageContentVC.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroPageContentVC : UIViewController

@property (assign, nonatomic) NSUInteger pageIndex;

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle bgImageName:(NSString *)imageName;

@end
