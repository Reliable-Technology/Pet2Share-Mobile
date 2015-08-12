//
//  CollectionViewLayout.m
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout

- (void)setupLayout:(CollectionLayout)layoutType cellHeight:(CGFloat)cellHeight spacing:(CGFloat)spacing
{
    CGSize itemSize;
    CGFloat width = self.collectionView.frame.size.width;
    
    switch (layoutType)
    {
        case OneColumn:
            itemSize = CGSizeMake(width-2*spacing, cellHeight);
            break;
            
        case TwoColumns:
            itemSize = CGSizeMake((width-3*spacing)/2, cellHeight);
            break;
            
        case ThreeColumns:
            itemSize = CGSizeMake((width-4*spacing)/3, cellHeight);
            break;
            
        default:
            itemSize = CGSizeMake(width-2*spacing, cellHeight);
            break;
    }
    
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
