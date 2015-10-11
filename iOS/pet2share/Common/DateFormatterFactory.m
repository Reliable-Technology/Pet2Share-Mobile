//
//  DateFormatterFactory.m
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "DateFormatterFactory.h"

// Define the default cache limit only if not defined by the host application code
#ifndef DATEFORMATTERFACTORY_CACHE_LIMIT
#define DATEFORMATTERFACTORY_CACHE_LIMIT 15
#endif

@implementation DateFormatterFactory

#pragma mark -
#pragma mark Static Methods

+ (DateFormatterFactory *)sharedFactory {
    static DateFormatterFactory *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [DateFormatterFactory new];
    });
    
    return sharedInstance;
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (self)
    {
        loadedDataFormatters = [[NSCache alloc] init];
        loadedDataFormatters.countLimit = DATEFORMATTERFACTORY_CACHE_LIMIT;
    }
    return self;
}

#pragma mark -
#pragma mark Public Instance Methods

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocale:(NSLocale *)locale
{
    @synchronized(self)
    {
        NSString *key = [NSString stringWithFormat:@"%@|%@", format, locale.localeIdentifier];
        NSDateFormatter *dateFormatter = [loadedDataFormatters objectForKey:key];
        if (!dateFormatter)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = format;
            dateFormatter.locale = locale;
            [loadedDataFormatters setObject:dateFormatter forKey:key];
        }
        return dateFormatter;
    }
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocaleIdentifier:(NSString *)localeIdentifier
{
    return [self dateFormatterWithFormat:format andLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
{
    return [self dateFormatterWithFormat:format andLocale:[NSLocale currentLocale]];
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocale:(NSLocale *)locale
{
    @synchronized(self)
    {
        NSString *key = [NSString stringWithFormat:@"d%lu|t%lu%@", (unsigned long)dateStyle, (unsigned long)timeStyle, locale.localeIdentifier];
        NSDateFormatter *dateFormatter = [loadedDataFormatters objectForKey:key];
        if (!dateFormatter)
        {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = dateStyle;
            dateFormatter.timeStyle = timeStyle;
            dateFormatter.locale = locale;
            [loadedDataFormatters setObject:dateFormatter forKey:key];
        }
        return dateFormatter;
    }
    
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocaleIdentifier:(NSString *)localeIdentifier
{
    return [self dateFormatterWithDateStyle:dateStyle timeStyle:timeStyle andLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle
{
    return [self dateFormatterWithDateStyle:dateStyle timeStyle:timeStyle andLocale:[NSLocale currentLocale]];
}

@end
