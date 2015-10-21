//
//  CheckMark.h
//  pet2share
//
//  Created by Tony Kieu on 10/21/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CheckMarkStyle)
{
    CheckMarkStyleOpenCircle,
    CheckMarkStyleGrayedOut
};

@interface CheckMark : UIControl

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) CheckMarkStyle checkMarkStyle;

@end
