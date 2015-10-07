//
//  ErrorMessage.m
//  pet2share
//
//  Created by Tony Kieu on 10/5/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ErrorMessage.h"

@implementation ErrorMessage

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Msg": @"message",
              @"ReasonCode": @"reasonCode"}];
}

- (BOOL)isValidate
{
    return YES;
}

@end
