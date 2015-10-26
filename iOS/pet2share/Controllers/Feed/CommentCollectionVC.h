//
//  CommentCollectionVC.h
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

@class Post;

#import "CollectionViewController.h"
#import "CellButtonDelegate.h"

typedef NS_ENUM(NSInteger, CommentMode)
{
    ShowComment,
    PostComment
};

@interface CommentCollectionVC : CollectionViewController

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) id<CellButtonDelegate> buttonDelegate;
@property (assign, nonatomic) CommentMode commentMode;

@end
