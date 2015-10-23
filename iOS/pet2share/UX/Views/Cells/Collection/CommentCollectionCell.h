//
//  CommentCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCollectionCell : UICollectionViewCell

+ (CGFloat)defaultHeight;
+ (CGFloat)heightByText:(NSString *)text itemWidth:(CGFloat)itemWidth;
- (void)loadDataWithImageUrl:(NSString *)imgUrl
        placeHolderImageName:(NSString *)placeHolderImgName
                sessionImage:(UIImage *)sessionImage
                  headerText:(NSString *)headerText
             descriptionText:(NSString *)descriptionText
                  statusText:(NSString *)statusText;

@end
