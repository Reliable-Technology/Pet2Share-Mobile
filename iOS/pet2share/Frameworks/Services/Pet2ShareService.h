//
//  Pet2ShareService.h
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSConstants.h"

@protocol Pet2ShareServiceCallback <NSObject>

- (void)onReceiveSuccess:(NSArray *)objects;
- (void)onReceiveError:(ErrorMessage *)errorMessage;

@end

@interface Pet2ShareService : NSObject

@property (nonatomic, strong) Class jsonModel;

- (void)loginUser:(NSObject<Pet2ShareServiceCallback> *)callback
     username:(NSString *)username
     password:(NSString *)password;

- (void)registerUser:(NSObject<Pet2ShareServiceCallback> *)callback
           firstname:(NSString *)firstname
            lastname:(NSString *)lastname
            username:(NSString *)username
            password:(NSString *)password
               phone:(NSString *)phone;


@end
