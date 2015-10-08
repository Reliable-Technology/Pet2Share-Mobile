//
//  Graphics.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SIAlertView/SIAlertView.h>
#import "AppColorScheme.h"

typedef NS_ENUM(NSInteger, AlertType)
{
    NormalAlert,
    WarningAlert,
    ErrorAlert
};

@interface Graphics : NSObject

#pragma mark - Alerts

+ (void)alert:(NSString *)title message:(NSString *)message type:(AlertType)type;
+ (void)promptAlert:(NSString *)title message:(NSString *)message type:(AlertType)type
                 ok:(SIAlertViewHandler)okHandler
             cancel:(SIAlertViewHandler)cancelHandler;

#pragma mark - Color

+ (UIColor *)lighterColorForColor:(UIColor *)color;
+ (UIColor *)darkerColorForColor:(UIColor *)color;

#pragma mark - Views

+ (void)roundView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
    shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset;
+ (void)dropShadow:(UIView *)view shadowOpacity:(CGFloat)shadowOpacity
      shadowRadius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset;
+ (UIImage *)circleImage:(UIImage*)image frame:(CGRect)frame;
+ (CGSize)getDeviceSize;

@end
