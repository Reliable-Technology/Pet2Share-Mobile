//
//  AppData.h
//  pet2share
//
//  Created by Tony Kieu on 10/15/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

+ (AppData *)sharedInstance;
- (void)addObject:(id)obj forKey:(NSString *)key;
- (void)removeObject:(NSString *)key;
- (id)getObject:(NSString *)key;

@end

