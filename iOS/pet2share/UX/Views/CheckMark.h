//
//  CheckMark.h
//  pet2share
//
//  Created by Tony Kieu on 8/16/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
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

