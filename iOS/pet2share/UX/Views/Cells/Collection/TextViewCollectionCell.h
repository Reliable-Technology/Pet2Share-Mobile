//
//  ActionCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/24/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

@interface TextViewCollectionCell : UICollectionViewCell

@property (nonatomic, readonly) NSInteger remainCharacters;

+ (CGFloat)height;
- (void)loadCellWithPlaceholder:(NSString *)placeHolder
                 inputAccessory:(UIView *)inputAccessory
                       protocol:(id<FormProtocol>)protocol;

@end
