//
//  AppColorScheme.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "AppColorScheme.h"

@implementation AppColorScheme

#define RGB(r,g,b) \
{ \
    static UIColor *rgb; \
    if (!rgb) rgb = [UIColor colorWithRed: r / 255.0 green: g / 255.0 blue: b / 255.0 alpha: 1.0]; \
    return rgb; \
}

+ (UIColor *)blue           { return [UIColor flatSkyBlueColor]; }
+ (UIColor *)darkBlueColor  { return [UIColor flatBlueColorDark]; }
+ (UIColor *)black			{ return [UIColor flatBlackColor]; }
+ (UIColor *)green          { return [UIColor flatGreenColorDark]; }
+ (UIColor *)darkGray		{ return [UIColor flatGrayColorDark]; }
+ (UIColor *)lightGray		{ return [UIColor flatGrayColor]; }
+ (UIColor *)purple         RGB(127,     92,     230)
+ (UIColor *)violet         { return [UIColor flatPurpleColorDark]; }
+ (UIColor *)red			{ return [UIColor flatRedColor]; }
+ (UIColor *)pink			{ return [UIColor flatPinkColor]; }
+ (UIColor *)orange         { return [UIColor flatOrangeColor]; }
+ (UIColor *)yellow         { return [UIColor flatYellowColor]; }
+ (UIColor *)white			{ return [UIColor flatWhiteColor]; }
+ (UIColor *)clear          {return [ UIColor clearColor];}
+ (UIColor *)systemDarkGray RGB(84,     84,     84)
+ (UIColor *)silver         RGB(177,    179,    182)
+ (UIColor *)lightSilver	RGB(209,    211,    212)


@end
