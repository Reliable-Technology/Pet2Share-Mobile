//
//  SignUpTableCtrl.h
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormProtocol.h"

@interface SignUpTableCtrl : UITableViewController

@property (nonatomic, weak) id<FormProtocol> formProtocol;

- (NSString *)firstname;
- (NSString *)lastname;
- (NSString *)email;
- (NSString *)password;
- (void)resignAllTextFields;
- (void)clearTextFields;

@end
