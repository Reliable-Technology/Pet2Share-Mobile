//
//  ParseComment.h
//  pet2share
//
//  Created by Tony Kieu on 8/6/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Parse/Parse.h>

@class ParseUser;
@class ParsePet;
@class ParsePost;

@interface ParseComment : PFObject <PFSubclassing>

/*!
 @abstract User
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) ParseUser *user;

/*!
 @abstract Pet
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) ParsePet *pet;

/*!
 @abstract Post
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) ParsePost *post;

/*!
 @abstract text
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *text;

@end
