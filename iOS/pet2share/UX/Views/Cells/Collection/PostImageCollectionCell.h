//
//  PostImageCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/22/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButtonDelegate.h"

@interface PostImageCollectionCell : UICollectionViewCell

+ (CGFloat)defaultHeight;
+ (CGFloat)heightByText:(NSString *)text itemWidth:(CGFloat)itemWidth;
- (void)loadDataWithImageUrl:(NSString *)imgUrl
        placeHolderImageName:(NSString *)placeHolderImgName
                sessionImage:(UIImage *)sessionImage
                    delegate:(id<CellButtonDelegate>)delegate
                      postId:(NSInteger)postId
                  isPostById:(NSInteger)isPostById
                 isPostByPet:(BOOL)isPostByPet
                postImageUrl:(NSString *)postImgUrl
                 primaryText:(NSString *)primaryText
               secondaryText:(NSString *)secondaryText
             descriptionText:(NSString *)descriptionText
                  statusText:(NSString *)statusText;

@end
