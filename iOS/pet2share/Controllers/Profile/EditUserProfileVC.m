//
//  EditUserProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <DBCamera/DBCameraContainerViewController.h>
#import "DBCameraLibraryViewController.h"
#import "EditUserProfileVC.h"
#import "Utils.h"
#import "Graphics.h"
#import "ActivityView.h"
#import "OrderedDictionary.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "ProfileBasicInfoCell.h"
#import "TextFieldTableCell.h"
#import "ProfileAddressInfoCell.h"
#import "TextViewTableCell.h"
#import "ImageActionSheet.h"

static NSString * const kCellBasicInfoIdentifier            = @"basicinfocell";
static NSString * const kCellOtherInfoIdentifier            = @"otherinfocell";
static NSString * const kCellAddressInfoIdentifier          = @"addressinfocell";
static NSString * const kCellAboutMeIdentifier              = @"aboutmecell";
static NSString * const kCellBasicInfoNibName               = @"ProfileBasicInfoCell";
static NSString * const kCellOtherInfoNibName               = @"TextFieldTableCell";
static NSString * const kCellAddressInfoNibName             = @"ProfileAddressInfoCell";
static NSString * const kCellAboutMeNibName                 = @"TextViewTableCell";

static NSString * const kCellClassName                      = @"cellclass";
static NSString * const kCellTag                            = @"celltag";
static NSString * const kCellHeight                         = @"cellheight";

static NSString * const kInputTypeKey                       = @"inputtype";
static NSString * const kPhoneKey                           = @"phone";
static NSString * const kDateOfBirthKey                     = @"dateofbirth";
static NSString * const kAboutMeKey                         = @"aboutme";

static CGFloat const kHeaderFontSize                        = 13.0f;
static CGFloat const kHeaderPadding                         = 16.0f;
#define kFirstSectionTitle                                  NSLocalizedString(@"Basic Info", @"")
#define kSecondSectionTitle                                 NSLocalizedString(@"Other Info", @"")
#define kThirdSectionTitle                                  NSLocalizedString(@"Address", @"")
#define KFourthSectionTitle                                 NSLocalizedString(@"About Me", @"")

@interface EditUserProfileVC () <BarButtonsProtocol, Pet2ShareServiceCallback,
UITableViewDataSource, UITableViewDelegate, FormProtocol,
CellButtonDelegate, ImageActionSheetDelegate, DBCameraViewControllerDelegate>
{
    BOOL _isDirty;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ActivityView *activity;
@property (strong, nonatomic) MutableOrderedDictionary *cellData;
@property (strong, nonatomic) NSMutableDictionary *unsavedData;
@property (strong, nonatomic) NSArray *availableButtons;
@property (strong, nonatomic) ImageActionSheet *actionSheet;

@end

@implementation EditProfileVC

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
        _cellData = [MutableOrderedDictionary dictionary];
        _isDirty = NO;
        _unsavedData = [NSMutableDictionary dictionary];
        _availableButtons = @[@(IMAGE_BUTTON_UPLOADIMAGE), @(IMAGE_BUTTON_TAKEPICTURE)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    self.title = NSLocalizedString(@"EDIT PROFILE", @"");

    // Activity View
    _activity = [[ActivityView alloc] initWithView:self.view];
    
    // UITableViewCell registration
    [self.tableView registerNib:[UINib nibWithNibName:kCellBasicInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellBasicInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kCellOtherInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellOtherInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kCellAddressInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellAddressInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kCellAboutMeNibName bundle:nil]
         forCellReuseIdentifier:kCellAboutMeIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Request profile data
    [self loadCellData];
    
    // Keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc
{
    TRACE_HERE;
    self.tableView = nil;
    self.activity = nil;
    self.cellData = nil;
    self.unsavedData = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Events

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
        [self.tableView setContentInset:edgeInsets];
        [self.tableView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.tableView setContentInset:edgeInsets];
        [self.tableView setScrollIndicatorInsets:edgeInsets];
    }];
}

#pragma mark -
#pragma mark Private Instance Methods

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
            
            NSArray *cellBasicInfo = @[@{kUserNameImageIcon: @"icon-user-selected",
                                         kFirstNameImageIcon: @"icon-contact-selected",
                                         kLastNameImageIcon: @"icon-contact-selected",
                                         kCellImageLink: currentUser.person.avatarUrl ?: kEmptyString,
                                         kUserNameKey: currentUser.email ?: kEmptyString,
                                         kFirstNameKey: currentUser.person.firstName ?: kEmptyString,
                                         kLastNameKey: currentUser.person.lastName ?: kEmptyString,
                                         kCellClassName: kCellBasicInfoNibName}];
            [self.cellData setObject:cellBasicInfo forKey:kCellBasicInfoIdentifier];
            
            ///------------------------------------------------
            /// Other Info
            ///------------------------------------------------
            
            NSArray *cellDetailInfo = @[@{kTextCellImageIcon: @"icon-phone-selected",
                                          kTextCellKey: currentUser.phone ?: kEmptyString,
                                          kCellTag: kPhoneKey,
                                          kInputTypeKey: @(InputTypePhonePad),
                                          kCellClassName: kCellOtherInfoNibName},
                                        @{kTextCellImageIcon: @"icon-birthdaycake-selected",
                                          kTextCellKey: [Utils formatNSDateToString:currentUser.person.dateOfBirth],
                                          kCellTag: kDateOfBirthKey,
                                          kInputTypeKey: @(InputTypeDate),
                                          kCellClassName: kCellOtherInfoNibName}];
            [self.cellData setObject:cellDetailInfo forKey:kCellOtherInfoIdentifier];
            
            ///------------------------------------------------
            /// Address Info
            ///------------------------------------------------
            
            Address *address = currentUser.person.address;
            
            if (address)
            {
                NSArray *addressInfo = @[@{kAddressImageIconKey: @"icon-home-selected",
                                           kCityImageIconKey: @"icon-city",
                                           kAddressKey: address.addressLine1 ?: kEmptyString,
                                           kCityKey: address.city ?: kEmptyString,
                                           kStateKey: address.state ?: kEmptyString,
                                           kZipCodeKey: address.zipCode ?: kEmptyString,
                                           kCellClassName: kCellAddressInfoNibName}];
                [self.cellData setObject:addressInfo forKey:kCellAddressInfoIdentifier];
            }
            
            ///------------------------------------------------
            /// About Me
            ///------------------------------------------------
            
            NSArray *aboutMeInfo = @[@{kTextViewKey: currentUser.person.aboutMe ?: kEmptyString,
                                       kCellTag: kAboutMeKey}];
            [self.cellData setObject:aboutMeInfo forKey:kCellAboutMeIdentifier];
            
            ///------------------------------------------------
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
    
    Pet2ShareUser *currentUser = [Pet2ShareUser current];
    
    for (NSString *key in self.unsavedData)
    {
        id value = self.unsavedData[key];
        
        if ([key isEqualToString:kFirstNameKey])
            currentUser.person.firstName = value;
        else if ([key isEqualToString:kLastNameKey])
            currentUser.person.lastName = value;
        else if ([key isEqualToString:kPhoneKey])
        {
            currentUser.phone = value;
            currentUser.person.primaryPhone = value;
        }
        else if ([key isEqualToString:kDateOfBirthKey])
            currentUser.person.dateOfBirth
            = (Date *)[Utils formatStringToNSDate:value withFormat:kFormatDateUS];
        else if ([key isEqualToString:kAddressKey])
            currentUser.person.address.addressLine1 = value;
        else if ([key isEqualToString:kCityKey])
            currentUser.person.address.city = value;
        else if ([key isEqualToString:kStateKey])
            currentUser.person.address.state = value;
        else if ([key isEqualToString:kZipCodeKey])
            currentUser.person.address.zipCode = value;
        else if ([key isEqualToString:kAboutMeKey])
            currentUser.person.aboutMe = value;
        else
            fTRACE(@"Unrecognized Key: %@ - Value: %@", key, value);
    }
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service updateUserProfile:self
                        userId:currentUser.identifier
                     firstName:currentUser.person.firstName
                      lastName:currentUser.person.lastName
                         email:currentUser.email
                alternateEmail:currentUser.alternateEmail
                         phone:currentUser.phone
                secondaryPhone:currentUser.person.secondaryPhone
                   dateOfBirth:currentUser.person.dateOfBirth
                       aboutMe:currentUser.person.aboutMe
                  addressLine1:currentUser.person.address.addressLine1
                  addressLine2:currentUser.person.address.addressLine2
                          city:currentUser.person.address.city
                         state:currentUser.person.address.state
                       country:currentUser.person.address.country
                       zipCode:currentUser.person.address.zipCode];
}

#pragma mark -
#pragma mark <Pet2ShareServiceCallback>

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

#pragma mark -
#pragma mark <BarButtonsProtocol>

- (UIButton *)setupLeftBarButton
{
    return [Graphics createBarButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
}

- (UIButton *)setupRightBarButton
{
    return [Graphics createBarButtonWithTitle:NSLocalizedString(@"DONE", @"")];
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

#pragma mark -
#pragma mark <FormProtocol>

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
    // fTRACE(@"Key: %@ - Value: %@", key, value);
    if (value) [self.unsavedData setObject:value forKey:key];
}

#pragma mark -
#pragma mark Profile Image Update

- (void)editButtonTapped:(id)sender
{
    _actionSheet = [[ImageActionSheet alloc] initWithTitle:NSLocalizedString(@"Upload Profile Picture", @"")
                                                  delegate:self
                                          availableButtons:self.availableButtons
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"")];
    [self.actionSheet showInViewController:self];
}

- (void)actionSheet:(ImageActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case IMAGE_BUTTON_UPLOADIMAGE:
        {
            DBCameraLibraryViewController *vc = [[DBCameraLibraryViewController alloc] init];
            [vc setDelegate:self];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        default: break;
    }
}

- (void)dismissCamera:(id)cameraViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    [cameraViewController restoreFullScreenMode];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    NSString *uniqueImageName = [Utils getUniqueFileName:@"userprofileavatar"];
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service uploadImage:self
                  userId:[Pet2ShareUser current].identifier
                fileName:uniqueImageName
                   image:image
          isCoverPicture:NO];
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
    NSString *sectionKey = [self.cellData keyAtIndex:indexPath.section];
    if ([sectionKey isEqualToString:kCellBasicInfoIdentifier])
        return [ProfileBasicInfoCell cellHeight];
    else if ([sectionKey isEqualToString:kCellOtherInfoIdentifier])
        return [TextFieldTableCell cellHeight];
    else if ([sectionKey isEqualToString:kCellAddressInfoIdentifier])
        return [ProfileAddressInfoCell cellHeight];
    else if ([sectionKey isEqualToString:kCellAboutMeIdentifier])
        return [TextViewTableCell cellHeightForText:[Pet2ShareUser current].person.aboutMe];
    else return 0;
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cellData count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = tableView.bounds.size.width;
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, kHeaderFontSize+kHeaderPadding*2)];
    headerView.backgroundColor = [AppColorScheme white];
    headerView.userInteractionEnabled = YES;
    headerView.tag = section;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHeaderPadding, kHeaderPadding/2, width-kHeaderPadding, kHeaderFontSize)];
    headerLabel.backgroundColor = [AppColorScheme clear];
    headerLabel.textColor = [AppColorScheme darkGray];
    headerLabel.font = [UIFont boldSystemFontOfSize:kHeaderFontSize];
    [headerView addSubview:headerLabel];
    
    // Header Text
    NSString *sectionKey = [self.cellData keyAtIndex:section];
    fTRACE(@"Section Key: %@", sectionKey);
    if ([sectionKey isEqualToString:kCellBasicInfoIdentifier])          headerLabel.text = [kFirstSectionTitle uppercaseString];
    else if ([sectionKey isEqualToString:kCellOtherInfoIdentifier])     headerLabel.text = [kSecondSectionTitle uppercaseString];
    else if ([sectionKey isEqualToString:kCellAddressInfoIdentifier])   headerLabel.text = [kThirdSectionTitle uppercaseString];
    else if ([sectionKey isEqualToString:kCellAboutMeIdentifier])       headerLabel.text = [KFourthSectionTitle uppercaseString];
    else headerLabel.text = kEmptyString;
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *data = [self.cellData objectAtIndex:section];
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    NSInteger section = indexPath.section;
    UITableViewCell *cell;
    
    @try
    {
        NSDictionary *data = [self.cellData objectAtIndex:section][index];
        NSString *reuseIdentifier = [self.cellData keyAtIndex:section];
        
        Class cellClass = NSClassFromString(data[kCellClassName]);
        cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:reuseIdentifier];
        
        if ([reuseIdentifier isEqualToString:kCellBasicInfoIdentifier])
        {
            [(ProfileBasicInfoCell *)cell setFormProtocol:self];
            [(ProfileBasicInfoCell *)cell setButtonDelegate:self];
            [(ProfileBasicInfoCell *)cell updateCell:data];
        }
        else if ([reuseIdentifier isEqualToString:kCellOtherInfoIdentifier])
        {
            ((TextFieldTableCell *)cell).formProtocol = self;
            [(TextFieldTableCell *)cell setFormProtocol:self];
            [(TextFieldTableCell *)cell updateTextField:data[kTextCellKey]
                                          iconImageName:data[kTextCellImageIcon]
                                                    tag:data[kCellTag]
                                              inputType:[data[kInputTypeKey] integerValue]];
        }
        else if ([reuseIdentifier isEqualToString:kCellAddressInfoIdentifier])
        {
            [(ProfileAddressInfoCell *)cell setFormProtocol:self];
            [(ProfileAddressInfoCell *)cell updateCell:data];
        }
        else if ([reuseIdentifier isEqualToString:kCellAboutMeIdentifier])
        {
            [(TextViewTableCell *)cell setFormProtocol:self];
            [(TextViewTableCell *)cell updateCell:data[kTextViewKey] tag:data[kCellTag]];
        }
        else
        {
            fTRACE(@"Error - Unrecognized Identifier %@", reuseIdentifier);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"cell"];
    }
    return cell;
}

@end