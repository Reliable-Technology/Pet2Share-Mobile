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
              @"PostURL": @"postUrl",
              @"SUser": @"user",
              @"SPet": @"pet",
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

- (NSString *)getPostStatusString
{
    NSString *likeStringCount = self.postLikeCount == 1
    ? [NSString stringWithFormat:@"%ld Like", (long)self.postLikeCount]
    : [NSString stringWithFormat:@"%ld Likes", (long)self.postLikeCount];
    NSString *commentStringCount = self.postCommentCount == 1
    ? [NSString stringWithFormat:@"%ld Comment", (long)self.postCommentCount]
    : [NSString stringWithFormat:@"%ld Comments", (long)self.postCommentCount];
    NSString *postStatus = [NSString stringWithFormat:@"%@ • %@", likeStringCount, commentStringCount];
    return postStatus;
}

@end
