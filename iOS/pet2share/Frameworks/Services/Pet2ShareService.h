//
//  Pet2ShareService.h
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Pet2ShareServiceCallback <NSObject>

- (void)onReceiveSuccess:(id)object;
- (void)onReceiveError:(id)object;

@end

@interface Pet2ShareService : NSObject

@property (nonatomic, strong) Class jsonModel;

- (void)login:(NSObject<Pet2ShareServiceCallback> *)callback
     username:(NSString *)username
     password:(NSString *)password;

@end
