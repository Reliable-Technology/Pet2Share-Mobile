//
//  FeedDetailTableVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "FeedDetailTableVC.h"
#import "WSConstants.h"
#import "PostDetailTextCell.h"
#import "CommentCell.h"
#import "InputTableView.h"
#import "Graphics.h"
#import "RoundCornerButton.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "PlaceHolderTextView.h"
#import "RoundCornerButton.h"

@interface FeedDetailTableVC () <KeyboardBarDelegate, Pet2ShareServiceCallback>

@property (strong, nonatomic) NSMutableArray *cellData;
@property (strong, nonatomic) InputTableView *inputTableView;
@property (strong, nonatomic) KeyboardBar *keyboarBar;

@end

@implementation FeedDetailTableVC

static NSString * const kPostDetailTextCellIdenfier     = @"postdetailtextcell";
static NSString * const kPostDetailTextCellNibName      = @"PostDetailTextCell";
static NSString * const kCommentCellIdentifier          = @"commentcell";
static NSString * const kCommentCellNibName             = @"CommentCell";
static NSString * const kCellReuseIdentifier            = @"cellIdentifier";

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _cellData = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup table view
    self.tableView = [[InputTableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // Pass the current controller as the keyboardBarDelegate
    ((InputTableView *)self.tableView).keyboardBarDelegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:kPostDetailTextCellNibName bundle:nil]
         forCellReuseIdentifier:kPostDetailTextCellIdenfier];
    [self.tableView registerNib:[UINib nibWithNibName:kCommentCellNibName bundle:nil]
         forCellReuseIdentifier:kCommentCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // Keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Initialize data
    [self initCellData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.inputAccessoryView.frame = CGRectMake(0.0f, -50.0f, self.tableView.frame.size.width, 44);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView endEditing:YES];
}

- (void)dealloc
{
    TRACE_HERE;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 
#pragma mark Private Instance Methods

- (void)initCellData
{
    @try
    {
        NSDictionary *profileCellDict = @{kCellClassName: kPostDetailTextCellNibName,
                                          kCellNameKey: self.post.user.name ?: kEmptyString,
                                          kCellImageLink: self.post.user.profilePictureUrl ?: kEmptyString,
                                          kCellDateKey: self.post.dateAdded ?: [NSNull class],
                                          kCellTextKey: self.post.postDescription,
                                          kCellReuseIdentifier: kPostDetailTextCellIdenfier};
        [self.cellData addObject:profileCellDict];
        
        for (Comment *comment in self.post.comments)
        {
            NSDictionary *profileCellDict = @{kCellClassName: kCommentCellNibName,
                                              kCellNameKey: comment.user.name ?: kEmptyString,
                                              kCellImageLink: comment.user.profilePictureUrl ?: kEmptyString,
                                              kCellDateKey: comment.dateAdded ?: [NSNull class],
                                              kCellCommentKey: comment.commentDescription,
                                              kCellReuseIdentifier: kCommentCellIdentifier};
            [self.cellData addObject:profileCellDict];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark <KeyboardBarDelegate>

- (void)keyboardBar:(KeyboardBar *)keyboardBar sendText:(NSString *)text
{
    if ([text isEqualToString:kEmptyString])
    {
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Comment is empty", @"")
                   type:ErrorAlert];
        return;
    }
    
    self.keyboarBar = keyboardBar;
    [keyboardBar.actionButton showActivityIndicator];
    Pet2ShareService *service = [Pet2ShareService new];
    [service addComment:self postId:self.post.identifier commentById:[Pet2ShareUser current].identifier isCommentedByPet:NO commentDescription:text];
}

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height-93, 0);
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
#pragma mark <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    Pet2ShareUser *currUser = [Pet2ShareUser current];
    NSString *name = [NSString stringWithFormat:@"%@ %@", currUser.person.firstName, currUser.person.lastName];
    
    NSDictionary *profileCellDict = @{kCellClassName: kCommentCellNibName,
                                      kCellNameKey: name ?: kEmptyString,
                                      kCellImageLink: currUser.person.profilePictureUrl ?: kEmptyString,
                                      kCellDateKey: [NSDate date] ?: [NSNull class],
                                      kCellCommentKey: self.keyboarBar.textView.text ?: kEmptyString,
                                      kCellReuseIdentifier: kCommentCellIdentifier};
    [self.cellData addObject:profileCellDict];
    [self.tableView reloadData];
    
    [self.keyboarBar.actionButton hideActivityIndicator];
    [self.keyboarBar.textView setText:nil];
    [self.tableView resignFirstResponder];
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [self.keyboarBar.actionButton hideActivityIndicator];
    [Graphics alert:NSLocalizedString(@"Error", @"")
            message:errorMessage.message
               type:ErrorAlert];
}

#pragma mark -
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    UITableViewCell *cell;
    
    @try
    {
        NSDictionary *data = [self.cellData objectAtIndex:index];
        NSString *reuseIdentifier = data[kCellReuseIdentifier];
        Class cellClass = NSClassFromString(data[kCellClassName]);
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:reuseIdentifier];
        
        if ([reuseIdentifier isEqualToString:kPostDetailTextCellIdenfier])
        {
            [(PostDetailTextCell *)cell update:data[kCellImageLink]
                                    postedName:data[kCellNameKey]
                                    postedDate:data[kCellDateKey]
                                          text:data[kCellTextKey]];
        }
        else if ([reuseIdentifier isEqualToString:kCommentCellIdentifier])
        {
            [(CommentCell *)cell update:data[kCellImageLink]
                          commentedName:data[kCellNameKey]
                            commentText:data[kCellCommentKey]
                             postedDate:data[kCellDateKey]];
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

#pragma mark -
#pragma mark <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.cellData[indexPath.row];
    if ([data[kCellReuseIdentifier] isEqualToString:kPostDetailTextCellIdenfier])
        return [PostDetailTextCell cellHeightForText:data[kCellTextKey]];
    else if ([data[kCellReuseIdentifier] isEqualToString:kCommentCellIdentifier])
        return [CommentCell cellHeightForText:data[kCellCommentKey]];
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

@end
