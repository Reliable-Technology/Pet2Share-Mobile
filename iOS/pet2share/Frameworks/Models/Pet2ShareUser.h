//
//  Pet2ShareUser.h
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSConstants.h"

@interface Pet2ShareUser : NSObject

+ (instancetype)current;
- (void)updateFromUser:(User *)user;

@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, readonly) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *alternateEmail;
@property (nonatomic, strong) NSString *socialMediaId;
@property (nonatomic, strong) NSString *socialMediaName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) SocialMediaSource *socialMediaSource;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) UserType *userType;
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, assign) BOOL isActive;

@end
