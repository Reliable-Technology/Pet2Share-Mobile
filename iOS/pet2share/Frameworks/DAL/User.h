//
//  User.h
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@class Person;
@class SocialMediaSource;
@class UserType;
@class Date;

@interface User : RepositoryObject

@property (readonly) NSInteger identifier;
@property (readonly) NSString<Optional> *username;
@property NSString<Optional> *password;
@property (readonly) BOOL isAuthenticated;
@property Person *person;
@property NSString *email;
@property NSString<Optional> *alternateEmail;
@property SocialMediaSource<Optional> *socialMediaSource;
@property NSString<Optional> *socialMediaId;
@property NSString<Optional> *socialMediaName;
@property NSString<Optional> *phone;
@property UserType<Optional> *userType;
@property Date *dateAdded;
@property Date *dateModified;
@property (readonly) BOOL isActive;

@end

@interface UserType : RepositoryObject

@property (readonly) NSInteger identifier;
@property NSString<Optional> *name;
@property NSDate *dateAdded;
@property NSDate *dateModified;
@property (readonly) BOOL isActive;
@property (readonly) BOOL isDeleted;

@end

@interface SocialMediaSource : RepositoryObject

@property (readonly) NSInteger identifier;
@property NSString<Optional> *name;
@property NSDate *dateAdded;
@property NSDate *dateModified;
@property (readonly) BOOL isActive;
@property (readonly) BOOL isDeleted;

@end