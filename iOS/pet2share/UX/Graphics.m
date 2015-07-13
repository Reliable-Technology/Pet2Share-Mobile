//
//  Graphics.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Graphics.h"

@implementation Graphics

#pragma mark - Private Helpers

+ (SIAlertView *)buildAlert:(NSString *)title message:(NSString *)message type:(AlertType)type
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    alertView.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:20.0f];
    alertView.messageFont = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0f];
    alertView.buttonFont = [UIFont fontWithName:@"AvenirNext-Regular" size:17.0f];
    alertView.cornerRadius = 5.0f;
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    alertView.buttonFont = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0f];
    
    switch (type)
    {
        case NormalAlert:
            alertView.titleColor = [AppColorScheme blue];
            break;
            
        case WarningAlert:
            alertView.titleColor = [AppColorScheme orange];
            break;
            
        case ErrorAlert:
            alertView.titleColor = [AppColorScheme red];
            break;
            
        default:
            alertView.titleColor = [AppColorScheme darkGray];
            break;
    }
    
    return alertView;
}

#pragma mark - Alert View

+ (void)alert:(NSString *)title message:(NSString *)message type:(AlertType)type
{
    SIAlertView *alertView = [self buildAlert:title message:message type:type];
    [alertView addButtonWithTitle:NSLocalizedString(@"OK", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {}];
    [alertView show];
    
}

+ (void)promptAlert:(NSString *)title message:(NSString *)message type:(AlertType)type
                 ok:(SIAlertViewHandler)okHandler
             cancel:(SIAlertViewHandler)cancelHandler
{
    SIAlertView *alertView = [self buildAlert:title message:message type:type];
    [alertView addButtonWithTitle:NSLocalizedString(@"OK", @"")
                             type:SIAlertViewButtonTypeDefault
                          handler:okHandler];
    [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:cancelHandler];
    [alertView show];
}

#pragma mark - Color

+ (UIColor *)lighterColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.1, 1.0)
                               green:MIN(g + 0.1, 1.0)
                                blue:MIN(b + 0.1, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}

@end
