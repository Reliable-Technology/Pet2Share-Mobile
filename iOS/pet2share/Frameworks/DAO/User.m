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
            @{@"id": @"identifier",
              @"firstName": @"firstName",
              @"lastName": @"lastName",
              @"email": @"email",
              @"mobile": @"mobile",
              @"phone": @"phone",
              @"addressLine1": @"addressLine1",
              @"addressLine2": @"addressLine2",
              @"city": @"city",
              @"country": @"country",
              @"zipCode": @"zipCode",
              @"createdDate": @"createdDate",
              @"password": @"password"}];
}

- (BOOL)validateObject
{
    // TODO: Implement later
    return YES;
}

@end