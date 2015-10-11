//
//  Utils.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

#pragma mark -
#pragma mark Validation Tools

+ (BOOL)validateAlpha:(NSString *)candidate;
+ (BOOL)validateAlphaSpaces:(NSString *)candidate;
+ (BOOL)validateAlphanumeric:(NSString *)candidate;
+ (BOOL)validateAlphanumericDash:(NSString *)candidate;
+ (BOOL)validateName:(NSString *)candidate;
+ (BOOL)validateStringInCharacterSet:(NSString *)string characterSet:(NSCharacterSet *)characterSet;
+ (BOOL)validateNotEmpty:(NSString *)candidate;
+ (BOOL)validateEmail:(NSString *)candidate;

#pragma mark -
#pragma mark Date

+ (NSDate *)deserializeJsonDateString:(NSString *)jsonDateString;
+ (NSString *)formatNSDateToDateTime:(NSDate *)date;
+ (NSString *)formatNSDateToString:(NSDate *)date;
+ (NSString *)formatNSDateToString:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)formatUTCStringToNSDate:(NSString *)dateStr;
+ (NSDate *)formatStringToNSDate:(NSString *)dateStr withFormat:(NSString *)format;

@end
