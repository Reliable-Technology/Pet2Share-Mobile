//
//  ParsePet.m
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ParsePet.h"

@implementation ParsePet

@dynamic nickName;
@dynamic name;
@dynamic avatarImage;
@dynamic owner;

+ (NSString *)parseClassName
{
    return @"Pet";
}

+ (void)load
{
    [self registerSubclass];
}

- (void)dealloc
{
    self.nickName = nil;
    self.name = nil;
    self.avatarImage = nil;
    self.owner = nil;
}

@end
