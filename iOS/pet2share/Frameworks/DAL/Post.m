//
//  Post.m
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"Id": @"identifier",
              @"PostTypeId": @"postTypeId",
              @"PostedBy": @"postedBy",
              @"SUser": @"user",
              @"Description": @"postDescription",
              @"Comments": @"comments",
              @"PostCommentCount": @"postCommentCount",
              @"PostLikeCount": @"postLikeCount",
              @"PostLikedBy": @"postLikedBy",
              @"IsPostByPet": @"isPostByPet",
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
