//
//  ActionCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/24/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButtonDelegate.h"

@interface ActionCollectionCell : UICollectionViewCell

@property (nonatomic, weak) id<CellButtonDelegate> buttonDelegate;

+ (CGFloat)height;
- (void)setButtonText:(NSString *)text;

@end
