//
//  User.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "User.h"

@implementation User

+ (JSONKeyMapper *) keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"FirstName": @"firstName",
              @"LastName": @"lastName",
              @"Email": @"email",
              @"Mobile": @"mobile",
              @"Phone": @"phone",
              @"AddressLine1": @"addressLine1",
              @"AddressLine2": @"addressLine2",
              @"City": @"city",
              @"Country": @"country",
              @"ZipCode": @"zipCode",
              @"CreatedDate": @"createdDate",
              @"Password": @"password"}];
}

- (BOOL)validateObject
{
    return YES;
}

@end