//
//  UrlManager.h
//  pet2share
//
//  Created by Tony Kieu on 8/2/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceConfig.h"

@interface UrlManager : NSObject

@property (nonatomic, strong) NSString *redirectionUrl;

+ (UrlManager *)sharedInstance;
- (NSString *)webServiceUrl;
- (NSString *)webServiceUrl:(NSString*)endpoint;

@end
