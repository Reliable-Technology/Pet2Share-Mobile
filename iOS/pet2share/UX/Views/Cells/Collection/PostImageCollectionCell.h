//
//  PostImageCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/22/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostImageCollectionCell : UICollectionViewCell

+ (CGFloat)defaultHeight;
+ (CGFloat)heightByText:(NSString *)text withImageHeight:(CGFloat)imageHeight itemWidth:(CGFloat)itemWidth;
- (void)loadDataWithImageUrl:(NSString *)imgUrl
             descriptionText:(NSString *)descriptionText;

@end
