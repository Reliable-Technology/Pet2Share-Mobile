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

@protocol Pet;

@interface User : RepositoryObject

@property NSInteger identifier;
@property NSString<Optional> *username;
@property NSString<Optional> *password;
@property BOOL isAuthenticated;
@property Person *person;
@property NSString *email;
@property NSString<Optional> *alternateEmail;
@property SocialMediaSource<Optional> *socialMediaSource;
@property NSString<Optional> *socialMediaId;
@property NSString<Optional> *socialMediaName;
@property NSString<Optional> *phone;
@property UserType<Optional> *userType;
@property NSArray<Pet, Optional> *pets;
@property Date *dateAdded;
@property Date *dateModified;
@property BOOL isActive;

@end

@interface UserType : RepositoryObject

@property NSInteger identifier;
@property NSString<Optional> *name;
@property NSDate *dateAdded;
@property NSDate *dateModified;
@property BOOL isActive;
@property BOOL isDeleted;

@end

@interface SocialMediaSource : RepositoryObject

@property NSInteger identifier;
@property NSString<Optional> *name;
@property NSDate *dateAdded;
@property NSDate *dateModified;
@property BOOL isActive;
@property BOOL isDeleted;

@end