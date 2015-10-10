//
//  Pet.h
//  pet2share
//
//  Created by Tony Kieu on 10/9/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@class PetType;
@class Date;

@interface Pet : RepositoryObject

@property NSInteger identifier;
@property NSString *name;
@property NSString *familyName;
@property NSInteger userIdentifier;
@property PetType<Optional> *petType;
@property Date *dateOfBirth;
@property NSString<Optional> *profilePicture;
@property NSString<Optional> *coverPicture;
@property NSString<Optional> *about;
@property NSString<Optional> *favFood;
@property Date *dateAdded;
@property Date *dateModified;
@property BOOL isActive;
@property BOOL isDeleted;

@end