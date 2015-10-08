//
//  CurrentUser.h
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSConstants.h"

@interface CurrentUser : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
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
