//
//  Comment.h
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@class SUser;
@class Date;

@interface Comment : RepositoryObject

@property NSInteger identifier;
@property NSString<Optional> *commentDescription;
@property NSInteger commentedBy;
@property BOOL isCommentedByPet;
@property NSInteger postId;
@property SUser<Optional> *user;
@property BOOL isActive;
@property BOOL isDeleted;
@property Date *dateAdded;
@property Date *dateModified;

@end
