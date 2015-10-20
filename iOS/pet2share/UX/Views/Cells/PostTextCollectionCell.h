//
//  PostTextCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTextCollectionCell : UICollectionViewCell

+ (CGFloat)defaultHeight;
+ (CGFloat)heightByText:(NSString *)text itemWidth:(CGFloat)itemWidth;
- (void)loadDataWithImageUrl:(NSString *)imgUrl
        placeHolderImageName:(NSString *)placeHolderImgName
                 primaryText:(NSString *)primaryText
               secondaryText:(NSString *)secondaryText
             descriptionText:(NSString *)descriptionText
                  statusText:(NSString *)statusText;

@end
