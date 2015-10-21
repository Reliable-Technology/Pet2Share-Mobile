//
//  PetCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Pet;

@interface PetCollectionCell : UICollectionViewCell

+ (CGFloat)height:(CGFloat)spacing;
- (void)setupView:(Pet *)pet;

@end
