//
//  Post.h
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"
#import "User.h"

typedef NS_ENUM(NSInteger, PostType)
{
    StatusUpdate,
    PostWithText,
    PostWithImage
};

@class Date;
@protocol SUser;
@protocol Comment;

@interface Post : RepositoryObject

@property NSInteger identifier;
@property PostType postTypeId;
@property NSInteger postedBy;
@property SUser<Optional> *user;
@property NSString <Optional> *postDescription;
@property NSArray<Comment> *comments;
@property NSInteger postCommentCount;
@property NSInteger postLikeCount;
@property NSArray <Optional> *postLikedBy;
@property BOOL isPostByPet;
@property BOOL isActive;
@property BOOL isDeleted;
@property Date *dateAdded;
@property Date *dateModified;

@end
