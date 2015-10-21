//
//  EmptyPetCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "EmptyPetCollectionCell.h"
#import "Graphics.h"

@implementation EmptyPetCollectionCell

+ (CGFloat)height:(CGFloat)spacing
{
    CGSize size = [Graphics getDeviceSize];
    
    // Consult xib for this value
    CGFloat footerHeight = 50.0f;
    
    // Get the actual width, we assume this is for two columns
    // layout.
    CGFloat actualImageWidth = size.width-3*spacing;
    
    // The picture at the bottom is changed due to device
    // We want to have 1:1 aspect ratio.
    CGFloat actualImageHeight = ceilf(actualImageWidth/2);
    
    // Actual cell height is the sum of header with image height
    CGFloat actualHeight = actualImageHeight+footerHeight;
    
    return actualHeight;
}

- (void)awakeFromNib
{
    [Graphics dropShadow:self shadowOpacity:0.5f shadowRadius:0.5f offset:CGSizeZero];
}

@end
