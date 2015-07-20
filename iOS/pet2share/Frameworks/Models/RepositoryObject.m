//
//  RepositoryObject.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@implementation RepositoryObject

+ (NSDictionary*)sortableMap
{
    return nil;
}

+ (NSArray *)sortableKeys
{
    return nil;
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (NSString*)uniqueId
{
    return [self description];
}

- (NSString*)filterTags
{
    return [self description];
}

- (BOOL)validateObject
{
    return NO;
}

@end