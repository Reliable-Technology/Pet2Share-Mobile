//
//  Pet.m
//  pet2share
//
//  Created by Tony Kieu on 10/9/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "Pet.h"

@implementation Pet

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"Name": @"name",
              @"FamilyName": @"familyName",
              @"UserId": @"userIdentifier",
              @"PetTypeId": @"petType",
              @"DOB": @"dateOfBirth",
              @"ProfilePicture": @"profilePicture",
              @"CoverPicture": @"coverPicture",
              @"ProfilePictureURL": @"profilePictureUrl",
              @"CoverPictureURL": @"coverPictureUrl",
              @"About": @"about",
              @"FavFood": @"favFood",
              @"DateAdded": @"dateAdded",
              @"DateModified": @"dateModified",
              @"IsActive": @"isActive",
              @"IsDeleted": @"isDeleted"}];
}

- (BOOL)isValidate
{
    return (self.identifier != -1 && self.name) ? YES : NO;
}

@end
