//
//  EditProfileVC.h
//  pet2share
//
//  Created by Tony Kieu on 10/14/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "BaseNavigationVC.h"
#import "OrderedDictionary.h"
#import "ActivityView.h"
#import "AppColor.h"
#import "Graphics.h"
#import "Utils.h"
#import "ProfileBasicInfoCell.h"
#import "ProfileNameInfoCell.h"
#import "TextFieldTableCell.h"
#import "ProfileAddressInfoCell.h"
#import "TextViewTableCell.h"

extern NSString * const kCellBasicInfoIdentifier;
extern NSString * const kCellNameInfoIdentifier;
extern NSString * const kCellOtherInfoIdentifier;
extern NSString * const kCellAddressInfoIdentifier;
extern NSString * const kCellAboutMeIdentifier;
extern NSString * const kCellBasicInfoNibName;
extern NSString * const kCellNameInfoNibName;
extern NSString * const kCellOtherInfoNibName;
extern NSString * const kCellAddressInfoNibName;
extern NSString * const kCellAboutMeNibName;

@interface EditProfileVC : BaseNavigationVC <FormProtocol>

@property (strong, nonatomic) MutableOrderedDictionary *cellData;
@property (strong, nonatomic) ActivityView *activity;

- (NSString *)getViewTitle;
- (NSString *)getSectionTitle:(NSString *)identifier;
- (void)assignTableView:(UITableView *)table;
- (CGFloat)getDynamicCellHeight:(NSString *)key;
- (void)initCellData;
- (void)alertSavingData;
- (void)updateServerData;

@end
