//
//  AppData.m
//  pet2share
//
//  Created by Tony Kieu on 10/15/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "AppData.h"

@implementation AppData
{
    NSMutableDictionary* dictionary;
}

+ (AppData *)sharedInstance
{
    static AppData *_appData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appData = [[AppData alloc] init];
    });
    return _appData;
}

- (id)init
{
    if ((self = [super init]))
    {
        dictionary = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)addObject:(id)obj forKey:(NSString *)key
{
    if (![self isValidKey:key])
    {
        return;
    }
    
    if (obj != nil)
    {
        [dictionary setObject:obj forKey:key];
    }
}

- (void)removeObject:(NSString *)key
{
    if (![self isValidKey:key])
    {
        return;
    }
    
    [dictionary removeObjectForKey:key];
}

- (id)getObject:(NSString *)key
{
    return ![self isValidKey:key] ? nil : [dictionary objectForKey:key];
}

- (BOOL)isValidKey:(NSString *)key
{
    return key != nil && ![key isEqualToString:kEmptyString];
}

@end
