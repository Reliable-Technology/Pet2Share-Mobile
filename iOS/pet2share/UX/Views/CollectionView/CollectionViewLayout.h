//
//  CollectionViewLayout.h
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "CSStickyHeaderFlowLayout.h"

typedef NS_ENUM(NSInteger, CollectionLayout)
{
    OneColumn,
    TwoColumns,
    ThreeColumns
};

@interface CollectionViewLayout : CSStickyHeaderFlowLayout

- (void)setupLayout:(CollectionLayout)layoutType cellHeight:(CGFloat)cellHeight spacing:(CGFloat)spacing;

@end
