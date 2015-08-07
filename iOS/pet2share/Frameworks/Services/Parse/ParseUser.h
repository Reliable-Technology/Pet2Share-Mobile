//
//  ParseUser.h
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Parse/Parse.h>

@interface ParseUser : PFUser <PFSubclassing>

/*!
 @abstract User First Name
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *firstName;

/*!
 @abstract User Last Name
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *lastName;

/*!
 @abstract User Phone Number
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *phone;

/*!
 @abstract User Mobile Number
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *mobile;

/*!
 @abstract User Address Line 1
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *addressLine1;

/*!
 @abstract User Address Line 2
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *addressLine2;

/*!
 @abstract User City
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *city;

/*!
 @abstract User Region State
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *regionState;

/*!
 @abstract User Country
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *country;

/*!
 @abstract User ZipCode
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *zipCode;

/*!
 @abstract User Avatar Image File
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) PFFile *avatarImage;

/*!
 @abstract User Email Verification Flag
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSNumber *emailVerified;

@end