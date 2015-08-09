//
//  PostCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParsePost;

@interface PostCollectionCell : UICollectionViewCell

+ (CGFloat)cellHeight;
- (void)setUpView:(ParsePost *)post;

@end
