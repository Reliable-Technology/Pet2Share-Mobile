//
//  JSONValueTransformer+Date.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "JSONValueTransformer+Date.h"
#import "Utils.h"

@implementation JSONValueTransformer (Date)

- (NSDate *)DateFromNSString:(NSString *)string
{
    return [Utils deserializeJsonDateString:string];
}

@end
