//
//  ParseComment.m
//  pet2share
//
//  Created by Tony Kieu on 8/6/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ParseComment.h"

@implementation ParseComment

@dynamic user;
@dynamic pet;
@dynamic post;
@dynamic text;

+ (NSString *)parseClassName
{
    return @"Comment";
}

+ (void)load
{
    [self registerSubclass];
}

- (void)dealloc
{
    self.user = nil;
    self.pet = nil;
    self.post = nil;
    self.text = nil;
}

@end