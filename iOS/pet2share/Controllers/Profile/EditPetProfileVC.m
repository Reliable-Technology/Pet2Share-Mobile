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
#import "ProfileBasicInfoCell.h"
#import "TextFieldTableCell.h"
#import "ProfileAddressInfoCell.h"
#import "TextViewTableCell.h"

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
#define kFirstSectionTitle                                  NSLocalizedString(@"Basic Pet Info", @"")
#define kSecondSectionTitle                                 NSLocalizedString(@"Other Pet Info", @"")
#define kThirdSectionTitle                                  NSLocalizedString(@"About Pet", @"")

@interface EditPetProfileVC () <BarButtonsProtocol, UITableViewDataSource, UITableViewDelegate, FormProtocol>
{
    BOOL _isDirty;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ActivityView *activity;
@property (strong, nonatomic) MutableOrderedDictionary *cellData;
@property (strong, nonatomic) NSDictionary *unsavedData;

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
    [self.tableView registerNib:[UINib nibWithNibName:kCellBasicInfoNibName bundle:nil]
         forCellReuseIdentifier:kCellBasicInfoIdentifier];
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
            
            NSArray *cellBasicInfo = @[@{kUserNameImageIcon: @"icon-user-selected",
                                         kFirstNameImageIcon: @"icon-contact-selected",
                                         kLastNameImageIcon: @"icon-contact-selected",
                                         kCellImageLink: self.pet.profilePicture ?: kEmptyString,
                                         kUserNameKey: self.pet.name ?: kEmptyString,
                                         kFirstNameKey: self.pet.name ?: kEmptyString,
                                         kLastNameKey: self.pet.familyName ?: kEmptyString,
                                         kCellClassName: kCellBasicInfoNibName}];
            [self.cellData setObject:cellBasicInfo forKey:kCellBasicInfoIdentifier];
            
            ///------------------------------------------------
            /// Other Info
            ///------------------------------------------------
            
            NSArray *cellDetailInfo = @[@{kTextCellImageIcon: @"icon-birthdaycake-selected",
                                          kTextCellKey: [Utils formatNSDateToString:self.pet.dateOfBirth],
                                          kCellTag: kDateOfBirthKey,
                                          kInputTypeKey: @(InputTypeDate),
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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark <FormProtocol>

- (void)performAction
{
    // No Implementation
}

- (void)fieldIsDirty
{
}

- (void)updateData:(NSString *)key value:(NSString *)value
{
    // fTRACE(@"Key: %@ - Value: %@", key, value);
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
    if ([sectionKey isEqualToString:kCellBasicInfoIdentifier])
        return [ProfileBasicInfoCell cellHeight];
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
    if ([sectionKey isEqualToString:kCellBasicInfoIdentifier])          headerLabel.text = [kFirstSectionTitle uppercaseString];
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
        
        if ([reuseIdentifier isEqualToString:kCellBasicInfoIdentifier]
            || [reuseIdentifier isEqualToString:kCellAddressInfoIdentifier])
        {
            [(ProfileBasicInfoCell *)cell setFormProtocol:self];
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
