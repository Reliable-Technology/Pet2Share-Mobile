//
//  InputTableView.h
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardBar.h"

@interface InputTableView : UITableView

@property (weak, nonatomic) id<KeyboardBarDelegate> keyboardBarDelegate;

@end
