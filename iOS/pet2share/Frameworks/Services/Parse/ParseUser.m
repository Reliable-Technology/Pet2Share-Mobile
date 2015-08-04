//
//  ParseUser.m
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ParseUser.h"

@implementation ParseUser

@dynamic firstName;
@dynamic lastName;
@dynamic phoneNumber;
@dynamic avatarImage;
@dynamic devices;
@dynamic emailVerified;

+ (void)load
{
    [self registerSubclass];
}

- (void)dealloc
{
    self.firstName = nil;
    self.lastName = nil;
    self.phoneNumber = nil;
    self.avatarImage = nil;
    self.devices = nil;
    self.emailVerified = nil;
}


@end
