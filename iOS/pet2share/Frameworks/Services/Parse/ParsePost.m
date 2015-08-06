//
//  ParsePost.m
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ParsePost.h"

@implementation ParsePost

@dynamic title;
@dynamic text;
@dynamic image;
@dynamic comments;

+ (NSString *)parseClassName
{
    return @"Post";
}

+ (void)load
{
    [self registerSubclass];
}

- (void)dealloc
{
    self.title = nil;
    self.text = nil;
    self.image = nil;
    self.comments = nil;
}

@end