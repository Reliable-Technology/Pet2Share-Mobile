//
//  ParsePost.h
//  pet2share
//
//  Created by Tony Kieu on 8/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Parse/Parse.h>

@class ParsePet;
@class ParseUser;

@interface ParsePost : PFObject <PFSubclassing>

/*!
 @abstract Title
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *title;

/*!
 @abstract text
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) NSString *text;

/*!
 @abstract image
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) PFFile *image;

/*!
 @abstract Pet
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) ParsePet *pet;

/*!
 @abstract Poster
 */
@property (PF_NULLABLE_PROPERTY nonatomic, strong) ParseUser *poster;

@end
