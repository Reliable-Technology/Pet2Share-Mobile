//
//  EditPetProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/12/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "EditPetProfileVC.h"
#import "Utils.h"
#import "Graphics.h"
#import "ActivityView.h"
#import "OrderedDictionary.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "ProfileNameInfoCell.h"
#import "TextFieldTableCell.h"
#import "ProfileAddressInfoCell.h"
#import "TextViewTableCell.h"

static NSString * const kCellNameInfoIdentifier             = @"nameinfocell";
static NSString * const kCellOtherInfoIdentifier            = @"otherinfocell";
static NSString * const kCellAddressInfoIdentifier          = @"addressinfocell";
static NSString * const kCellAboutMeIdentifier              = @"aboutmecell";
static NSString * const kCellNameInfoNibName                = @"ProfileNameInfoCell";
static NSString * const kCellOtherInfoNibName               = @"TextFieldTableCell";
static NSString * const kCellAddressInfoNibName             = @"ProfileAddressInfoCell";
static NSString * const kCellAboutMeNibName                 = @"TextViewTableCell";

static NSString * const kCellClassName                      = @"cellclass";
static NSString * const kCellTag                            = @"celltag";
static NSString * const kCellHeight                         = @"cellheight";

static NSString * const kInputTypeKey                       = @"inputtype";
static NSString * const kPhoneKey                           = @"phone";
static NSString * const kDateOfBirthKey                     = @"dateofbirth";
static NSString * const kFavFoodKey                         = @"favfood";
static NSString * const kAboutMeKey                         = @"aboutme";

static CGFloat const kHeaderFontSize                        = 13.0f;
static CGFloat const kHeaderPadding                         = 16.0f;
#define kFirstSectionTitle                                  NSLocalizedString(@"Basic Pet Info", @"")
#define kSecondSectionTitle                                 NSLocalizedString(@"Other Pet Info", @"")
#define kThirdSectionTitle                                  NSLocalizedString(@"About Pet", @"")

@interface EditPetProfileVC () <BarButtonsProtocol, Pet2ShareServiceCallback, UITableViewDataSource, UITableViewDelegate, FormProtocol>
{
    BOOL _isDirty;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ActivityView *activity;
@property (strong, nonatomic) MutableOrderedDictionary *cellData;
@property (strong, nonatomic) NSMutableDictionary *unsavedData;

@end

@implementation EditPetProfileVC

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
    
    // Title
    self.title = NSLocalizedString(@"PET EDIT PROFILE", @"");
    
    // UITableViewCell registration
    [self.tableView registerNib:[UINib nibWithNibName:kCellNameInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellNameInfoIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kCellOtherInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellOtherInfoIdentifier];
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
        if (self.pet)
        {
            ///------------------------------------------------
            /// Basic Info
            ///------------------------------------------------
            
            NSArray *cellBasicInfo = @[@{kFirstNameImageIcon: @"icon-contact-selected",
                                         kLastNameImageIcon: @"icon-contact-selected",
                                         kCellImageLink: self.pet.profilePicture ?: kEmptyString,
                                         kFirstNameKey: self.pet.name ?: kEmptyString,
                                         kLastNameKey: self.pet.familyName ?: kEmptyString,
                                         kCellClassName: kCellNameInfoNibName}];
            [self.cellData setObject:cellBasicInfo forKey:kCellNameInfoIdentifier];
            
            ///------------------------------------------------
            /// Other Info
            ///------------------------------------------------
            
            NSArray *cellDetailInfo = @[@{kTextCellImageIcon: @"icon-birthdaycake-selected",
                                          kTextCellKey: [Utils formatNSDateToString:self.pet.dateOfBirth],
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
            /// About Me
            ///------------------------------------------------
            
            NSArray *aboutMeInfo = @[@{kTextViewKey: self.pet.about ?: kEmptyString,
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

- (void)updatePetProfile
{
    [self.activity show];
    self.tableView.userInteractionEnabled = NO;
    
    // Update current user pet
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
    
    // Update the database
    Pet2ShareService *service = [Pet2ShareService new];
    [service updatePetProfile:self petId:self.pet.identifier
                       userId:[Pet2ShareUser current].identifier
                         name:self.pet.name
                   familyName:self.pet.familyName
                      petType:nil
                  dateOfBirth:self.pet.dateOfBirth
                        about:self.pet.about
                      favFood:self.pet.favFood];
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
                           [self updatePetProfile];
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
    if ([key isEqualToString:kFirstNameKey])
        self.pet.name = value;
    else if ([key isEqualToString:kLastNameKey])
        self.pet.familyName = value;
    else if ([key isEqualToString:kDateOfBirthKey])
        self.pet.dateOfBirth = (Date *)[Utils formatStringToNSDate:value withFormat:kFormatDateUS];
    else if ([key isEqualToString:kFavFoodKey])
        self.pet.favFood = value;
    else
        fTRACE(@"Unrecognized Key: %@ - Value: %@", key, value);
}

#pragma mark -
#pragma mark <UITableViewDelegate>

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
    if ([sectionKey isEqualToString:kCellNameInfoIdentifier])
        return [ProfileNameInfoCell cellHeight];
    else if ([sectionKey isEqualToString:kCellOtherInfoIdentifier])
        return [TextFieldTableCell cellHeight];
    else if ([sectionKey isEqualToString:kCellAboutMeIdentifier])
        return [TextViewTableCell cellHeightForText:self.pet.about];
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
    if ([sectionKey isEqualToString:kCellNameInfoIdentifier])          headerLabel.text = [kFirstSectionTitle uppercaseString];
    else if ([sectionKey isEqualToString:kCellOtherInfoIdentifier])     headerLabel.text = [kSecondSectionTitle uppercaseString];
    else if ([sectionKey isEqualToString:kCellAboutMeIdentifier])       headerLabel.text = [kThirdSectionTitle uppercaseString];
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
        
        if ([reuseIdentifier isEqualToString:kCellNameInfoIdentifier]
            || [reuseIdentifier isEqualToString:kCellAddressInfoIdentifier])
        {
            [(ProfileNameInfoCell *)cell setFormProtocol:self];
            [(ProfileNameInfoCell *)cell updateCell:data];
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