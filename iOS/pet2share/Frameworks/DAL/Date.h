//
//  Date.h
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This is a custom parser for the web service date. All date in DAL should be declared
 to this object so we can use the custom parser. This is nothing but a NSDate wrapper,
 used to trigger custom parser. Do not put any implementation here.
 */
@interface Date : NSDate

@end
