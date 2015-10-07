//
//  Address.m
//  pet2share
//
//  Created by Tony Kieu on 10/6/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "Address.h"

@implementation Address

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"AddressLine1": @"addressLine1",
              @"AddressLine2": @"addressLine2",
              @"City": @"city",
              @"Country": @"country",
              @"IsBillingAddress": @"isBillingAddress",
              @"IsShippingAddress": @"isShippingAddress",
              @"State": @"state",
              @"ZipCode": @"zipCode"}];
}

- (BOOL)isValidate
{
    return self.identifier != -1 ? NO : YES;
}

@end