//
//  PostNewVC.h
//  pet2share
//
//  Created by Tony Kieu on 10/16/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "BaseNavigationVC.h"

@protocol NewPostDelegate <NSObject>
- (void)didPost;

@end

@interface NewPostVC : BaseNavigationVC

@property (weak, nonatomic) id<NewPostDelegate> delegate;
@property (strong, nonatomic) UIImage *postImage;

@end
