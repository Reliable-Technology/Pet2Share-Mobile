//
//  ParsePet.h
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Parse/Parse.h>

@class ParseUser;

@interface ParsePet : PFObject <PFSubclassing>

/*!
 @abstract Nick Name
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *nickName;

/*!
 @abstract Name
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *name;

/*!
 @abstract Avatar Image
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) PFFile *avatarImage;

/*!
 @abstract Owner
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) ParseUser *owner;

@end
