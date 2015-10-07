//
//  ResponseObject.m
//  pet2share
//
//  Created by Tony Kieu on 9/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ResponseObject.h"

@implementation ResponseObject

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"ErrorMsg": @"errorMessage",
                                 @"Total": @"total",
                                 @"Results": @"results"}];
}

@end