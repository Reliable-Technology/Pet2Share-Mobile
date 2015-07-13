//
//  Utils.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark - Validation Tools

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

@end
