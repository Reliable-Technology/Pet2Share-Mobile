//
//  User.h
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@interface User : RepositoryObject

@property NSInteger identifier;
@property NSString  *firstName;
@property NSString  *lastName;
@property NSString  *email;
@property NSString  *mobile;
@property NSString  *phone;
@property NSString  *addressLine1;
@property NSString  *addressLine2;
@property NSString  *city;
@property NSString  *country;
@property NSString  *zipCode;
@property NSDate    *createdDate;
@property NSString  *password;

@end
