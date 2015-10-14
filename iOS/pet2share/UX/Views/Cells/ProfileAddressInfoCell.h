//
//  ProfileAddressInfoCell.h
//  pet2share
//
//  Created by Tony Kieu on 10/11/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"
#import "CellConstants.h"

@interface ProfileAddressInfoCell : UITableViewCell

@property (nonatomic, weak) id<FormProtocol> formProtocol;

+ (CGFloat)cellHeight;
- (void)updateCell:(NSDictionary *)dict;

@end
