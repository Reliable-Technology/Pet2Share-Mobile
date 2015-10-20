//
//  CollectionViewLayout.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout

+ (CGFloat)getItemWidth:(CGFloat)width layoutType:(CollectionLayout)layoutType spacing:(CGFloat)spacing
{
    switch (layoutType)
    {
        case OneColumn:     return width - 2 * spacing;
        case TwoColumns:    return (width - 3 * spacing) / 2;
        case ThreeColumns:  return (width - 4 * spacing)/ 3;
        default:            return width - 2 * spacing;
    }
}

- (void)setupLayout:(CollectionLayout)layoutType cellHeight:(CGFloat)cellHeight spacing:(CGFloat)spacing
{
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat itemWidth = [CollectionViewLayout getItemWidth:width layoutType:layoutType spacing:spacing];
    CGSize itemSize = CGSizeMake(itemWidth, cellHeight);
    
    DEBUG_SIZE("Collection Item Size", itemSize);
    
    self.itemSize = itemSize;
    self.headerReferenceSize = CGSizeMake(0.0f, 0.0f);
    self.footerReferenceSize = CGSizeMake(0.0f, 0.0f);
    self.minimumInteritemSpacing = spacing;
    self.minimumLineSpacing = spacing;
    self.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

- (void)setupLayout:(CollectionLayout)layoutType cellHeight:(CGFloat)cellHeight verticalSpacing:(CGFloat)verticalSpacing horizontalSpacing:(CGFloat)horizontalSpacing
{
    CGSize itemSize;
    CGFloat width = self.collectionView.frame.size.width;
    
    switch (layoutType)
    {
        case OneColumn:
            itemSize = CGSizeMake(width-2*horizontalSpacing, cellHeight);
            break;
            
        case TwoColumns:
            itemSize = CGSizeMake((width-3*horizontalSpacing)/2, cellHeight);
            break;
            
        case ThreeColumns:
            itemSize = CGSizeMake((width-4*horizontalSpacing)/3, cellHeight);
            break;
            
        default:
            itemSize = CGSizeMake(width-2*horizontalSpacing, cellHeight);
            break;
    }
    
    DEBUG_SIZE("Collection Item Size", itemSize);
    
    self.itemSize = itemSize;
    self.headerReferenceSize = CGSizeMake(0.0f, 0.0f);
    self.footerReferenceSize = CGSizeMake(0.0f, 0.0f);
    self.minimumInteritemSpacing = horizontalSpacing;
    self.minimumLineSpacing = verticalSpacing;
    self.sectionInset = UIEdgeInsetsMake(verticalSpacing, horizontalSpacing, verticalSpacing, horizontalSpacing);
}

@end
