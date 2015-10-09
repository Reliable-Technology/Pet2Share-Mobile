//
//  Person.h
//  pet2share
//
//  Created by Tony Kieu on 10/6/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@class Address;
@class Date;

@interface Person : RepositoryObject

@property NSInteger identifier;
@property NSString<Optional> *firstName;
@property NSString<Optional> *lastName;
@property NSString<Optional> *email;
@property Date *dateOfBirth;
@property Address<Optional> *address;
@property NSString<Optional> *primaryPhone;
@property NSString<Optional> *secondaryPhone;
@property NSString<Optional> *avatarUrl;
@property NSString<Optional> *aboutMe;
@property Date *dateAdded;
@property Date *dateModified;
@property BOOL isActive;

@end