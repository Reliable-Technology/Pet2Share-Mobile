//
//  TextViewTableCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

@interface TextViewTableCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;

+ (CGFloat)cellHeightForText:(NSString *)text;
- (void)updateCell:(NSString *)text tag:(NSString *)tag;

@end
