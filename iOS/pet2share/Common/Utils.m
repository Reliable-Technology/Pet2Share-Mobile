//
//  Utils.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Utils.h"
#import "Constants.h"
#import "DateFormatterFactory.h"

@implementation Utils

#pragma mark -
#pragma mark Common

+ (NSString *)jsonRepresentation:(NSDictionary *)dict
{
    NSString *result = kEmptyString;
    
    @try
    {
        NSError *error;
        NSData *json = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
        result = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: exception occurred: %@", __func__, exception);
    }
    
    return result;
}

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGSize size = CGSizeZero;
    if (text)
    {
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:font}
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}

+ (NSString *)getUniqueFileName:(NSString *)fileName
{
    long long timeStamp = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@_%lld", fileName, timeStamp];
    return uniqueFileName;
}

#pragma mark -
#pragma mark Validation Tools

+ (BOOL)validateAlpha:(NSString *)candidate
{
    return [self validateStringInCharacterSet:candidate characterSet:[NSCharacterSet letterCharacterSet]];
}

+ (BOOL)validateAlphaSpaces:(NSString *)candidate
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet addCharactersInString:@" "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

+ (BOOL)validateAlphanumeric:(NSString *)candidate
{
    return [self validateStringInCharacterSet:candidate characterSet:[NSCharacterSet alphanumericCharacterSet]];
}

+ (BOOL)validateAlphanumericDash:(NSString *)candidate
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"-_."];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

+ (BOOL)validateName:(NSString *)candidate
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"'- "];
    return [self validateStringInCharacterSet:candidate characterSet:characterSet];
}

+ (BOOL)validateStringInCharacterSet:(NSString *)string characterSet:(NSCharacterSet *)characterSet
{
    // Since we invert the character set if it is == NSNotFound then it is in the character set.
    return ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) ? NO : YES;
}

+ (BOOL)validateNotEmpty:(NSString *)candidate
{
    return ([candidate length] == 0) ? NO : YES;
}

+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark -
#pragma mark Date

+ (NSDate *)deserializeJsonDateString:(NSString *)jsonDateString
{
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT];
    NSInteger startPosition = [jsonDateString rangeOfString:@"("].location + 1;
    NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000;
    NSDate *date = [[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
    
    return date;
}

+ (id)formatNSDateToDateTime:(NSDate *)date
{
    if (!date) return [NSNull new];
    
    NSDateFormatter *formatter = [[DateFormatterFactory sharedFactory] dateFormatterWithFormat:@"Z"];
    NSString *jsonDate = [NSString stringWithFormat:@"/Date(%.0f000%@)/",
                          [date timeIntervalSince1970], [formatter stringFromDate:date]];
    return jsonDate;
}

+ (NSString *)formatNSDateToString:(NSDate *)date
{
    return [self formatNSDateToString:date withFormat:kFormatDateUS];
}

+ (NSString *)formatNSDateToString:(NSDate *)date withFormat:(NSString *)format
{
    if (!date) return kEmptyString;
    
    NSDateFormatter *dateFormatter = [[DateFormatterFactory sharedFactory] dateFormatterWithFormat:format
                                                                                         andLocale:[NSLocale currentLocale]];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)formatUTCStringToNSDate:(NSString *)dateStr
{
    return [self formatStringToNSDate:dateStr withFormat:kFormatDateUTC];
}

+ (NSDate *)formatStringToNSDate:(NSString *)dateStr withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[DateFormatterFactory sharedFactory] dateFormatterWithFormat:format
                                                                                         andLocale:[NSLocale currentLocale]];
    return [dateFormatter dateFromString:dateStr];
}

@end