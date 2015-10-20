//
//  CollectionViewLayout.h
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CSStickyHeaderFlowLayout.h"

typedef NS_ENUM(NSInteger, CollectionLayout)
{
    OneColumn,
    TwoColumns,
    ThreeColumns
};

@interface CollectionViewLayout : CSStickyHeaderFlowLayout

+ (CGFloat)getItemWidth:(CGFloat)width layoutType:(CollectionLayout)layoutType spacing:(CGFloat)spacing;
- (void)setupLayout:(CollectionLayout)layoutType cellHeight:(CGFloat)cellHeight spacing:(CGFloat)spacing;
- (void)setupLayout:(CollectionLayout)layoutType cellHeight:(CGFloat)cellHeight verticalSpacing:(CGFloat)verticalSpacing horizontalSpacing:(CGFloat)horizontalSpacing;

@end
