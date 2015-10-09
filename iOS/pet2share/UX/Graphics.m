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

#pragma mark - Views

+ (void)roundView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
    shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset
{
    view.layer.cornerRadius = cornerRadius;
    [self dropShadow:view shadowOpacity:cornerRadius shadowRadius:shadowRadius offset:shadowOffset];
}

+ (void)dropShadow:(UIView *)view shadowOpacity:(CGFloat)shadowOpacity
      shadowRadius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset
{
    view.layer.masksToBounds = NO;
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    view.layer.shouldRasterize = YES;
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}

+ (UIImage *)circleImage:(UIImage*)image frame:(CGRect)frame
{
    // Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    // Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    // Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    // Set the SCALE factor for the graphics context
    // All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height )
    {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)tintImage:(UIImage *)source withColor:(UIColor *)color
{
    // Begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // Get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the fill color
    [color setFill];
    
    // Translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // Generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the color-burned image
    return coloredImg;
}

+ (CGSize)getDeviceSize
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    return screenBounds.size;
}

@end