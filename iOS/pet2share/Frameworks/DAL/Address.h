//
//  Address.h
//  pet2share
//
//  Created by Tony Kieu on 10/6/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@interface Address : RepositoryObject

@property NSInteger identifier;
@property NSString<Optional> *addressLine1;
@property NSString<Optional> *addressLine2;
@property NSString<Optional> *city;
@property NSString<Optional> *country;
@property (readonly) BOOL isBillingAddress;
@property (readonly) BOOL isShippingAddress;
@property NSString<Optional> *state;
@property NSString<Optional> *zipCode;

@end
