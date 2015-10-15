//
//  EditProfileVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/14/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "EditProfileVC.h"
#import "ImageActionSheet.h"

static CGFloat const kHeaderFontSize            = 13.0f;
static CGFloat const kHeaderPadding             = 16.0f;

@interface EditProfileVC () <BaseNavigationProtocol, UITableViewDataSource, UITableViewDelegate,
CellButtonDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL _isDirty;
}

@property (strong, nonatomic) UITableView *table;

@end

@implementation EditProfileVC

NSString * const kCellBasicInfoIdentifier       = @"basicinfocell";
NSString * const kCellNameInfoIdentifier        = @"nameinfocell";
NSString * const kCellOtherInfoIdentifier       = @"otherinfocell";
NSString * const kCellAddressInfoIdentifier     = @"addressinfocell";
NSString * const kCellAboutMeIdentifier         = @"aboutmecell";
NSString * const kCellBasicInfoNibName          = @"ProfileBasicInfoCell";
NSString * const kCellNameInfoNibName           = @"ProfileNameInfoCell";
NSString * const kCellOtherInfoNibName          = @"TextFieldTableCell";
NSString * const kCellAddressInfoNibName        = @"ProfileAddressInfoCell";
NSString * const kCellAboutMeNibName            = @"TextViewTableCell";

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _isDirty = NO;
        self.baseNavProtocol = self;
        _cellData = [MutableOrderedDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View title
    self.title = [self getViewTitle];
    
    // Activity View
    _activity = [[ActivityView alloc] initWithView:self.view];
    
    // Keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    // Init cell data
    [self initCellData];
    [self.table reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    TRACE_HERE;
    self.table = nil;
    self.activity = nil;
    self.cellData = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Protected Instance Methods

- (NSString *)getViewTitle
{
    // Need to be implemented at subclass
    return kEmptyString;
}

- (CGFloat)getDynamicCellHeight:(NSString *)key
{
    // Need to be implemented at subclass
    return 0;
}

- (NSString *)getAvatarImageKey
{
    // Need to be implemented at subclass
    return nil;
}

- (NSString *)getSectionTitle:(NSString *)identifier
{
    // Need to be implemented at subclass
    return kEmptyString;
}

- (void)assignTableView:(UITableView *)table
{
    self.table = table;
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.table registerNib:[UINib nibWithNibName:kCellBasicInfoNibName bundle:nil] forCellReuseIdentifier:kCellBasicInfoIdentifier];
    [self.table registerNib:[UINib nibWithNibName:kCellNameInfoNibName bundle:nil] forCellReuseIdentifier:kCellNameInfoIdentifier];
    [self.table registerNib:[UINib nibWithNibName:kCellOtherInfoNibName bundle:nil] forCellReuseIdentifier:kCellOtherInfoIdentifier];
    [self.table registerNib:[UINib nibWithNibName:kCellAddressInfoNibName bundle:nil] forCellReuseIdentifier:kCellAddressInfoIdentifier];
    [self.table registerNib:[UINib nibWithNibName:kCellAboutMeNibName bundle:nil] forCellReuseIdentifier:kCellAboutMeIdentifier];
}

- (void)initCellData
{
    // Need to be implemented at subclass
}

- (void)alertSavingData
{
    // Need to be implemented at subclass
}

- (void)updateServerData
{
    // Need to be implemented at subclass
}

#pragma mark -
#pragma mark Events

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
        [self.table setContentInset:edgeInsets];
        [self.table setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.table setContentInset:edgeInsets];
        [self.table setScrollIndicatorInsets:edgeInsets];
    }];
}

///--------------------------------------------------------------------
/// Delegates & Protocols callbacks
///--------------------------------------------------------------------

#pragma mark -
#pragma mark <BaseNavigationProtocol>

- (UIButton *)setupLeftBarButton
{
    return [Graphics createBarButtonWithTitle:NSLocalizedString(@"DONE", @"")];
}

- (UIButton *)setupRightBarButton
{
    return [Graphics createBarButtonWithTitle:NSLocalizedString(@"CANCEL", @"")];
}

- (void)handleLeftButtonEvent:(id)sender
{
    if (!_isDirty)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self alertSavingData];
}

- (void)handleRightButtonEvent:(id)sender
{
    [[AppData sharedInstance] removeObject:[self getAvatarImageKey]];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleActionButton:(NSInteger)buttonIndex
{
    @try
    {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        switch (buttonIndex)
        {
            case IMAGE_BUTTON_CHOOSEFROMALBUM:
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
                break;
            }
                
            case IMAGE_BUTTON_TAKEPICTURE:
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:nil];
                break;
            }
                
            default: break;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Camera is not available", @"")
                   type:ErrorAlert];
    }
}

#pragma mark -
#pragma mark <CellButtonDelegate>

- (void)editButtonTapped:(id)sender
{
    [self setupActionSheet:nil buttons:@[@(IMAGE_BUTTON_CHOOSEFROMALBUM), @(IMAGE_BUTTON_TAKEPICTURE)]];
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

#pragma mark -
#pragma mark <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    fTRACE(@"Info: %@", info);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /** Info Example
     * UIImagePickerControllerCropRect = "NSRect: {{0, 0}, {2668, 1772}}";
     * UIImagePickerControllerEditedImage = "<UIImage: 0x7fa49f896350> size {748, 496} orientation 0 scale 1.000000";
     * UIImagePickerControllerMediaType = "public.image";
     * UIImagePickerControllerOriginalImage = "<UIImage: 0x7fa49f895ec0> size {2668, 1772} orientation 0 scale 1.000000";
     * UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=D77460CE-4855-4A54-BE4D-5C0A84C7742B&ext=JPG";
     */
    
    // Notify form is dirty and save image to current session.
    _isDirty = YES;
    [[AppData sharedInstance] addObject:info[UIImagePickerControllerOriginalImage]
                                 forKey:[self getAvatarImageKey]];
    [self.table reloadData];
}

///--------------------------------------------------------------------
/// This handles all delegate and datasource methods of the UITableView
///--------------------------------------------------------------------

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
    headerLabel.text = [self getSectionTitle:sectionKey] ?: kEmptyString;
    fTRACE(@"Section Key: %@ - Text: %@", sectionKey, headerLabel.text);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [self.cellData keyAtIndex:indexPath.section];
    if ([sectionKey isEqualToString:kCellBasicInfoIdentifier])
        return [ProfileBasicInfoCell cellHeight];
    else if ([sectionKey isEqualToString:kCellNameInfoIdentifier])
        return [ProfileNameInfoCell cellHeight];
    else if ([sectionKey isEqualToString:kCellOtherInfoIdentifier])
        return [TextFieldTableCell cellHeight];
    else if ([sectionKey isEqualToString:kCellAddressInfoIdentifier])
        return [ProfileAddressInfoCell cellHeight];
    else return [self getDynamicCellHeight:sectionKey];
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cellData count];
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
        NSMutableDictionary *data = [self.cellData objectAtIndex:section][index];
        NSString *reuseIdentifier = [self.cellData keyAtIndex:section];
        
        Class cellClass = NSClassFromString(data[kCellClassName]);
        cell = [self.table dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:reuseIdentifier];
        
        if ([reuseIdentifier isEqualToString:kCellBasicInfoIdentifier])
        {
            if ([[AppData sharedInstance] getObject:[self getAvatarImageKey]])
                data[kCellAvatarImage] = [[AppData sharedInstance] getObject:[self getAvatarImageKey]];
            [(ProfileBasicInfoCell *)cell setFormProtocol:self];
            [(ProfileBasicInfoCell *)cell setButtonDelegate:self];
            [(ProfileBasicInfoCell *)cell updateCell:data];
        }
        else if ([reuseIdentifier isEqualToString:kCellNameInfoIdentifier])
        {
            if ([[AppData sharedInstance] getObject:[self getAvatarImageKey]])
                data[kCellAvatarImage] = [[AppData sharedInstance] getObject:[self getAvatarImageKey]];
            [(ProfileNameInfoCell *)cell setFormProtocol:self];
            [(ProfileNameInfoCell *)cell setButtonDelegate:self];
            [(ProfileNameInfoCell *)cell updateCell:data];
        }
        else if ([reuseIdentifier isEqualToString:kCellOtherInfoIdentifier])
        {
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
        cell = [self.table dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"cell"];
    }
    return cell;
}

///--------------------------------------------------------------------

@end