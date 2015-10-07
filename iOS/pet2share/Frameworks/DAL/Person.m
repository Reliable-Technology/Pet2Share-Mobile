//
//  Person.m
//  pet2share
//
//  Created by Tony Kieu on 10/6/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"FirstName": @"firstName",
              @"LastName": @"lastName",
              @"Email": @"email",
              @"DOB": @"dateOfBirth",
              @"Addr": @"address",
              @"PrimaryPhone": @"primaryPhone",
              @"SecondaryPhone": @"secondaryPhone",
              @"AvatarURL": @"avatarUrl",
              @"AboutMe": @"aboutMe",
              @"DateAdded": @"dateAdded",
              @"dateModified": @"dateModified",
              @"IsActive": @"isActive"}];
}

- (BOOL)isValidate
{
    return self.identifier != -1 ? YES : NO;
}

@end
