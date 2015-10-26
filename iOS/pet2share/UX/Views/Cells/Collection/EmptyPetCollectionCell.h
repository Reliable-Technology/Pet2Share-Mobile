//
//  EmptyPetCollectionCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyPetCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *addPetBtn;

+ (CGFloat)height:(CGFloat)spacing;

@end
