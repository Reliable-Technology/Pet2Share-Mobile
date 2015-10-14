//
//  EditUserProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "EditUserProfileVC.h"
#import "Pet2ShareUser.h"
#import "Pet2ShareService.h"

@interface EditUserProfileVC () <Pet2ShareServiceCallback>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *unsavedUserData;

@end

@implementation EditUserProfileVC

#pragma mark - 
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _unsavedUserData = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Assign table view
    [self assignTableView:self.tableView];
}

#pragma mark -
#pragma mark Superclass Instance Methods

- (NSString *)getViewTitle
{
    return NSLocalizedString(@"EDIT PROFILE", @"");
}

- (NSString *)getSectionTitle:(NSString *)identifier
{
    NSString *sectionTitle;
    
    if ([identifier isEqualToString:kCellBasicInfoIdentifier])
        sectionTitle = NSLocalizedString(@"Basic Info", @"");
    else if ([identifier isEqualToString:kCellOtherInfoIdentifier])
        sectionTitle = NSLocalizedString(@"Other Info", @"");
    else if ([identifier isEqualToString:kCellAddressInfoIdentifier])
        sectionTitle = NSLocalizedString(@"Address", @"");
    else if ([identifier isEqualToString:kCellAboutMeIdentifier])
        sectionTitle = NSLocalizedString(@"About Me", @"");
    else sectionTitle = kEmptyString;
    
    return [sectionTitle uppercaseString];
}

- (CGFloat)getDynamicCellHeight:(NSString *)key
{
    if ([key isEqualToString:kCellAboutMeIdentifier])
        return [TextViewTableCell cellHeightForText:[Pet2ShareUser current].person.aboutMe];
    else return 0.0f;
}

- (void)initCellData
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
}

- (void)alertSavingData
{
    [Graphics promptAlert:NSLocalizedString(@"Save Settings", @"")
                  message:NSLocalizedString(@"Do you want to save new user information?", @"")
                     type:NormalAlert
                       ok:^(SIAlertView *alert) {
                           [self updateServerData];
                       } cancel:^(SIAlertView *alert) {
                           return;
                       }];
}

- (void)updateServerData
{
    [self.activity show];
    self.tableView.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    
    Pet2ShareUser *currentUser = [Pet2ShareUser current];
    
    for (NSString *key in self.unsavedUserData)
    {
        id value = self.unsavedUserData[key];
        
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
#pragma mark <FormProtocol>

- (void)updateData:(NSString *)key value:(NSString *)value
{
    fTRACE(@"Key: %@ - Value: %@", key, value);
    if (value) self.unsavedUserData[key] = value;
}

@end