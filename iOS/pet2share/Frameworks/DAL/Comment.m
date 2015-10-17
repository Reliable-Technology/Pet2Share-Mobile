//
//  Comment.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "Comment.h"

@implementation Comment

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"CommentDescription": @"commentDescription",
              @"CommentedBy": @"commentedBy",
              @"IsCommentedByPet": @"isCommentedByPet",
              @"PostId": @"postId",
              @"SUser": @"user",
              @"IsActive": @"isActive",
              @"IsDeleted": @"isDeleted",
              @"DateAdded": @"dateAdded",
              @"DateModified": @"dateModified"}];
}

- (BOOL)isValidate
{
    return (self.identifier != -1) ? YES : NO;
}

@end
