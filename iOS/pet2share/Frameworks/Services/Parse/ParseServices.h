//
//  Header.h
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PFErrors.h"
#import "PFQueryCallback.h"
#import "PFQueryService.h"
#import "ParseUser.h"
#import "ParsePet.h"
#import "ParsePost.h"
#import "ParseComment.h"

static NSString * const kParsePetNickName       = @"nickName";
static NSString * const kParsePetName           = @"name";
static NSString * const kParsePetAvatarImage    = @"avatarImage";
static NSString * const kParsePetOwner          = @"owner";

static NSString * const kParsePostTitle         = @"title";
static NSString * const kParsePostText          = @"text";
static NSString * const kParsePostImage         = @"image";
static NSString * const kParsePostPet           = @"pet";
static NSString * const kParsePostPoster        = @"poster";