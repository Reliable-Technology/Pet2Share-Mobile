//
//  CacheKey.m
//  pet2share
//
//  Created by Tony Kieu on 10/15/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CacheKey.h"

@interface CacheKey()

@property (nonatomic, strong) NSMutableString *uniqueString;

@end

@implementation CacheKey

- (id)init
{
    if ((self = [super init]))
    {
        self.uniqueString = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (void)addKey:(NSString *)key
{
    [self.uniqueString appendString:key];
}

- (NSString *)getKey
{
    return self.uniqueString;
}

- (NSString *)description
{
    return self.getKey;
}

@end