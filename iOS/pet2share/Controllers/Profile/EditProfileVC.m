//
//  EditProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <DateTools/DateTools.h>
#import "EditProfileVC.h"
#import "Graphics.h"
#import "ActivityView.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "ProfileBasicInfoCell.h"
#import "ProfileDetailInfoCell.h"
#import "OrderedDictionary.h"

static NSString * const kCellProfileBasicInfoIdentifier     = @"profilebasicinfocell";
static NSString * const kCellProfileBasicInfoNibName        = @"ProfileBasicInfoCell";
static NSString * const kCellProfileDetailInfoIdentifier    = @"profiledetailinfocell";
static NSString * const kCellProfileDetailInfoNibName       = @"ProfileDetailInfoCell";
static NSString * const kCellIdentifier                     = @"cellidentifier";
static NSString * const kCellHeight                         = @"cellheight";
static NSInteger const kFirstSectionIndex                   = 0;
static NSInteger const kSecondSectionIndex                  = 1;

@interface EditProfileVC () <BarButtonsProtocol, Pet2ShareServiceCallback, UITableViewDataSource, UITableViewDelegate, FormProtocol>
{
    BOOL _isDirty;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ActivityView *activity;
@property (strong, nonatomic) MutableOrderedDictionary *cellData;
@property (strong, nonatomic) NSMutableDictionary *unsavedData;

@end

@implementation EditProfileVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
        _cellData = [MutableOrderedDictionary dictionary];
        _isDirty = NO;
        _unsavedData = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"EDIT PROFILE", @"");

    // Activity View
    _activity = [[ActivityView alloc] initWithView:self.view];
    
    // UITableViewCell registration
    [self.tableView registerNib:[UINib nibWithNibName:kCellProfileBasicInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellProfileBasicInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kCellProfileDetailInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellProfileDetailInfoIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Request profile data
    [self loadCellData];
}

#pragma mark - Private Instance Methods

- (UIButton *)createBarButtonWithTitle:(NSString *)title
{
    CGSize buttonSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:UIFontWeightBold]}];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    return button;
}

- (void)loadCellData
{
    @try
    {
        Pet2ShareUser *currentUser = [Pet2ShareUser current];
        
        if (currentUser.person)
        {
            ///------------------------------------------------
            /// Basic Info
            ///------------------------------------------------
            
            NSDictionary *cellBasicInfo = @{kCellImageIcon1: @"icon-user-selected",
                                            kCellImageIcon2: @"icon-contact-selected",
                                            kCellImageIcon3: @"icon-contact-selected",
                                            kCellImageLink: currentUser.person.avatarUrl ?: NSLocalizedString(@"N/A", @""),
                                            kCellNonEditText: currentUser.email ?: NSLocalizedString(@"N/A", @""),
                                            kCellEditText1: currentUser.person.firstName ?: NSLocalizedString(@"N/A", @""),
                                            kCellEditText2: currentUser.person.lastName ?: NSLocalizedString(@"N/A", @"")};
            [self.cellData insertObject:@[cellBasicInfo] forKey:kCellProfileBasicInfoIdentifier atIndex:kFirstSectionIndex];
            
            ///------------------------------------------------
            /// Detail Info
            ///------------------------------------------------
            
            NSString *dateOfBirthStr = currentUser.person.dateOfBirth
            ? [currentUser.person.dateOfBirth formattedDateWithFormat:kFormatDateUS]: NSLocalizedString(@"N/A", @"");
            
            Address *address = currentUser.person.address;
            NSMutableString *addressStr = [NSMutableString new];
            if (address)
            {
                if (address.addressLine1)
                {
                    [addressStr appendString:address.addressLine1];
                    [addressStr appendString:@", "];
                }
                if (address.city)
                {
                    [addressStr appendString:address.city];
                    [addressStr appendString:@", "];
                }
                if (address.state)
                {
                    [addressStr appendString:address.state];
                    [addressStr appendString:@", "];
                }
                if (address.zipCode)
                {
                    [addressStr appendString:address.zipCode];
                }
            }
            
            NSArray *cellDetailInfo = @[@{kCellImageIcon: @"icon-phone-selected",
                                          kCellEditText: currentUser.phone ?: NSLocalizedString(@"N/A", @""),
                                          kCellIdentifier: kPhoneKey},
                                        @{kCellImageIcon: @"icon-birthdaycake-selected",
                                          kCellEditText: dateOfBirthStr,
                                          kCellIdentifier: kDateOfBirthKey},
                                        @{kCellImageIcon: @"icon-home-selected",
                                          kCellEditText: [NSString stringWithString:addressStr],
                                          kCellIdentifier: kAddressKey}];
            [self.cellData insertObject:cellDetailInfo forKey:kCellProfileDetailInfoIdentifier atIndex:kSecondSectionIndex];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
    }
    
    [self.tableView reloadData];
}

- (void)updateUserProfile
{
    [self.activity show];
    self.tableView.userInteractionEnabled = NO;
    
    for (NSString *key in self.unsavedData)
    {
        id value = self.unsavedData[key];
        
        if ([key isEqualToString:kFirstNameKey])
            [Pet2ShareUser current].person.firstName = value;
        else if ([key isEqualToString:kLastNameKey])
            [Pet2ShareUser current].person.lastName = value;
        else if ([key isEqualToString:kPhoneKey])
        {
            [Pet2ShareUser current].phone = value;
            [Pet2ShareUser current].person.primaryPhone = value;
        }
        else if ([key isEqualToString:kDateOfBirthKey])
        {
            // TODO: Implement later
            // self.tempUser.person.dateOfBirth = (Date *)[NSDate dateWithString:value formatString:kFormatDateUS];
        }
        else if ([key isEqualToString:kAddressKey])
        {
            // TODO: Implement later
        }
    }
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service updateUserProfile:self
                        userId:[Pet2ShareUser current].identifier
                     firstName:[Pet2ShareUser current].person.firstName
                      lastName:[Pet2ShareUser current].person.lastName
                         email:[Pet2ShareUser current].email
                alternateEmail:[Pet2ShareUser current].alternateEmail
                         phone:[Pet2ShareUser current].phone
                secondaryPhone:[Pet2ShareUser current].person.secondaryPhone
                   dateOfBirth:[Pet2ShareUser current].person.dateOfBirth
                       aboutMe:[Pet2ShareUser current].person.aboutMe
                  addressLine1:[Pet2ShareUser current].person.address.addressLine1
                  addressLine2:[Pet2ShareUser current].person.address.addressLine2
                          city:[Pet2ShareUser current].person.address.city
                         state:[Pet2ShareUser current].person.address.state
                       country:[Pet2ShareUser current].person.address.country
                       zipCode:[Pet2ShareUser current].person.address.zipCode];
}

#pragma mark - <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    [self.activity hide];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [self.activity hide];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

#pragma mark - <BarButtonsProtocol>

- (UIButton *)setupLeftBarButton
{
    return [self createBarButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
}

- (UIButton *)setupRightBarButton
{
    return [self createBarButtonWithTitle:NSLocalizedString(@"DONE", @"")];
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleRightButtonEvent:(id)sender
{
    if (!_isDirty)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [Graphics promptAlert:NSLocalizedString(@"Save Settings", @"")
                  message:NSLocalizedString(@"Do you want to save new user information?", @"")
                     type:NormalAlert
                       ok:^(SIAlertView *alert) {
                           [self.view endEditing:YES];
                           [self updateUserProfile];
                       } cancel:^(SIAlertView *alert) {
                           return;
                       }];
}

#pragma mark - <FormProtocol>

- (void)performAction
{
    // No Implementation
}

- (void)fieldIsDirty
{
    if (!_isDirty) _isDirty = YES;
}

- (void)updateData:(NSString *)key value:(NSString *)value
{
    [self.unsavedData setObject:value forKey:key];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kFirstSectionIndex)
        return [ProfileBasicInfoCell cellHeight];
    else
        return [ProfileDetailInfoCell cellHeight];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cellData count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = tableView.bounds.size.width;
    int fontSize = 13.0f;
    int padding = 16.0f;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, fontSize+padding*2)];
    view.backgroundColor = [AppColorScheme white];
    view.userInteractionEnabled = YES;
    view.tag = section;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, 8.0f, width - padding, fontSize)];
    label.backgroundColor = [AppColorScheme clear];
    label.textColor = [AppColorScheme darkGray];
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    if (section == kFirstSectionIndex) label.text = [NSLocalizedString(@"Basic Info", @"") uppercaseString];
    else label.text = [NSLocalizedString(@"Other Info", @"") uppercaseString];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *data = [self.cellData objectAtIndex:section];
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger index = indexPath.row;
    NSInteger section = indexPath.section;
    NSDictionary *data = nil;
    
    @try
    {
        NSArray *dataList = [self.cellData objectAtIndex:section];
        NSString *reuseIdentifier = [self.cellData keyAtIndex:section];
        
        if ([reuseIdentifier isEqualToString:kCellProfileBasicInfoIdentifier])
        {
            data = dataList[index];
            ProfileBasicInfoCell *basicCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!basicCell) basicCell = [[ProfileBasicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                    reuseIdentifier:reuseIdentifier];
            [basicCell updateCell:data];
            basicCell.formProtocol = self;
            cell = basicCell;
        }
        else if ([reuseIdentifier isEqualToString:kCellProfileDetailInfoIdentifier])
        {
            data = dataList[index];
            ProfileDetailInfoCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!detailCell) detailCell = [[ProfileDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                       reuseIdentifier:reuseIdentifier];
            detailCell.formProtocol = self;
            [detailCell updateCell:data forTagKey:data[kCellIdentifier]];
            cell = detailCell;
        }
        else
        {
            fTRACE(@"Error - Unrecognized Identifier %@", reuseIdentifier);
            cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) cell = [[ProfileBasicInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:reuseIdentifier];
        }
        return cell;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
    }
}

@end