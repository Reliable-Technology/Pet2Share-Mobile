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
@dynamic phone;
@dynamic mobile;
@dynamic addressLine1;
@dynamic addressLine2;
@dynamic city;
@dynamic regionState;
@dynamic country;
@dynamic zipCode;
@dynamic avatarImage;
@dynamic coverImage;
@dynamic emailVerified;

+ (void)load
{
    [self registerSubclass];
}

- (void)dealloc
{
    self.firstName = nil;
    self.lastName = nil;
    self.phone = nil;
    self.mobile = nil;
    self.addressLine1 = nil;
    self.addressLine2 = nil;
    self.city = nil;
    self.regionState = nil;
    self.country = nil;
    self.zipCode = nil;
    self.avatarImage = nil;
    self.coverImage = nil;
    self.emailVerified = nil;
}


@end
