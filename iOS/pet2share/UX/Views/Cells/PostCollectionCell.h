//
//  PostCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Post;

@interface PostCollectionCell : UICollectionViewCell

+ (CGFloat)cellHeight:(CGFloat)spacing;
- (void)setUpView:(Post *)post;

@end
