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
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *phoneNumber;

/*!
 @abstract User Avatar Image File
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) PFFile *avatarImage;

/*!
 @abstract List of <Device>
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSArray *devices;

/*!
 @abstract User Email Verification Flag
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSNumber *emailVerified;

@end