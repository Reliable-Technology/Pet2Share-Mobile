//
//  LoginTableCtrl.h
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

@interface LoginTableCtrl : UITableViewController

@property (nonatomic, assign) id<FormProtocol> formProtocol;

- (NSString *)username;
- (NSString *)password;
- (void)resignAllTextFields;

@end
