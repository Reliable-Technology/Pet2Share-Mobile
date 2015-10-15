//
//  CacheKey.h
//  pet2share
//
//  Created by Tony Kieu on 10/15/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheKey : NSObject

@property (readonly) NSString *getKey;

- (void)addKey:(NSString *)key;

@end