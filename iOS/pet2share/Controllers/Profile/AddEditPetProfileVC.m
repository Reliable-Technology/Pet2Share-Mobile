//
//  AddEditPetProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/12/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "AddEditPetProfileVC.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "Pet.h"

@interface AddEditPetProfileVC () <Pet2ShareServiceCallback>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddEditPetProfileVC

#pragma mark -
#pragma mark Life Cycle

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
    switch (self.petProfileMode)
    {
        case AddPetProfile: return NSLocalizedString(@"ADD PET PROFILE", @"");
        case EditPetProfile: return NSLocalizedString(@"EDIT PET PROFILE", @"");
        default: return kEmptyString;
    }
}

- (NSString *)getSectionTitle:(NSString *)identifier
{
    NSString *sectionTitle;
    
    if ([identifier isEqualToString:kCellNameInfoIdentifier])
        sectionTitle = NSLocalizedString(@"Basic Pet Info", @"");
    else if ([identifier isEqualToString:kCellOtherInfoIdentifier])
        sectionTitle = NSLocalizedString(@"Other Pet Info", @"");
    else if ([identifier isEqualToString:kCellAboutMeIdentifier])
        sectionTitle = NSLocalizedString(@"About Pet", @"");
    else sectionTitle = kEmptyString;
    
    return [sectionTitle uppercaseString];
}

- (CGFloat)getDynamicCellHeight:(NSString *)key
{
    if ([key isEqualToString:kCellAboutMeIdentifier])
        return [TextViewTableCell cellHeightForText:self.pet.about];
    else return 0.0f;
}

- (void)initCellData
{
    @try
    {
        if (self.pet)
        {
            ///------------------------------------------------
            /// Basic Pet Info
            ///------------------------------------------------
            
            NSArray *cellBasicInfo = @[@{kFirstNameImageIcon: @"icon-contact-selected",
                                         kLastNameImageIcon: @"icon-contact-selected",
                                         kCellImageLink: self.pet.profilePicture ?: kEmptyString,
                                         kFirstNameKey: self.pet.name ?: kEmptyString,
                                         kLastNameKey: self.pet.familyName ?: kEmptyString,
                                         kCellClassName: kCellNameInfoNibName}];
            [self.cellData setObject:cellBasicInfo forKey:kCellNameInfoIdentifier];
            
            ///------------------------------------------------
            /// Other Pet Info
            ///------------------------------------------------
            
            NSArray *cellDetailInfo = @[@{kTextCellImageIcon: @"icon-birthdaycake-selected",
                                          kTextCellKey: [Utils formatNSDateToString:(NSDate *)self.pet.dateOfBirth],
                                          kCellTag: kDateOfBirthKey,
                                          kInputTypeKey: @(InputTypeDate),
                                          kCellClassName: kCellOtherInfoNibName},
                                        @{kTextCellImageIcon: @"icon-food-selected",
                                          kTextCellKey: self.pet.favFood ?: kEmptyString,
                                          kCellTag: kFavFoodKey,
                                          kInputTypeKey: @(InputTypeDefault),
                                          kCellClassName: kCellOtherInfoNibName}];
            [self.cellData setObject:cellDetailInfo forKey:kCellOtherInfoIdentifier];
            
            ///------------------------------------------------
            /// About Pet
            ///------------------------------------------------
            
            NSArray *aboutPetInfo = @[@{kTextViewKey: self.pet.about ?: kEmptyString,
                                        kCellTag: kAboutMeKey}];
            [self.cellData setObject:aboutPetInfo forKey:kCellAboutMeIdentifier];
            
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
    NSString *message = self.petProfileMode == AddPetProfile
    ? NSLocalizedString(@"Do you want to add new pet?", @"")
    : NSLocalizedString(@"Do you want to edit pet information?", @"");
    
    [Graphics promptAlert:NSLocalizedString(@"Save Settings", @"")
                  message:message
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
    
    Pet2ShareService *service = [Pet2ShareService new];
    
    switch (self.petProfileMode)
    {
        case AddPetProfile:     // Add new pet to the server database
        {
            [[Pet2ShareUser current].pets addObject:self.pet];
            [service insertPetProfile:self
                               userId:[Pet2ShareUser current].identifier
                                 name:self.pet.name
                           familyName:self.pet.familyName
                              petType:nil
                          dateOfBirth:self.pet.dateOfBirth
                                about:self.pet.about
                              favFood:self.pet.favFood];
            break;
        }
        
        case EditPetProfile:    // Edit current pet in the database
        {
            for (Pet *pet in [Pet2ShareUser current].pets)
            {
                if (pet.identifier == self.pet.identifier)
                {
                    pet.name = self.pet.name;
                    pet.familyName = self.pet.familyName;
                    pet.dateOfBirth = self.pet.dateOfBirth;
                    pet.favFood = self.pet.favFood;
                    pet.about = self.pet.about;
                    break;
                }
            }
            
            [service updatePetProfile:self
                                petId:self.pet.identifier
                               userId:[Pet2ShareUser current].identifier
                                 name:self.pet.name
                           familyName:self.pet.familyName
                              petType:nil
                          dateOfBirth:self.pet.dateOfBirth
                                about:self.pet.about
                              favFood:self.pet.favFood];
        }
            
        default: break;
    }
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
    if ([key isEqualToString:kFirstNameKey])
        self.pet.name = value;
    else if ([key isEqualToString:kLastNameKey])
        self.pet.familyName = value;
    else if ([key isEqualToString:kDateOfBirthKey])
        self.pet.dateOfBirth = (Date *)[Utils formatStringToNSDate:value withFormat:kFormatDateUS];
    else if ([key isEqualToString:kFavFoodKey])
        self.pet.favFood = value;
    else if ([key isEqualToString:kAboutMeKey])
        self.pet.about = value;
    else fTRACE(@"Unrecognized Key: %@ - Value: %@", key, value);
}

@end
