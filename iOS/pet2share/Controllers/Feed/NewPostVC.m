
//
//  PostNewVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/16/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "NewPostVC.h"
#import "PlaceHolderTextView.h"
#import "CircleImageView.h"
#import "Pet2ShareUser.h"
#import "Pet2ShareService.h"
#import "AppColor.h"
#import "Graphics.h"
#import "RoundCornerButton.h"

static CGFloat const kToolbarHeight = 44.0f;

@interface NewPostVC () <UITextViewDelegate, Pet2ShareServiceCallback>
{
    NSInteger _remainCharacters;
    NSInteger _profileId;
    BOOL _isPostedByPet;
}

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textView;
@property (strong, nonatomic) UILabel *remainCharacterLabels;
@property (strong, nonatomic) RoundCornerButton *postBtn;

- (IBAction)closeBtnTapped:(id)sender;

@end

@implementation NewPostVC

#pragma mark - 
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _remainCharacters = kPostMaxCharacters;
        _profileId = -1;
        _isPostedByPet = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load Profile Image
    Pet2ShareService *service = [Pet2ShareService new];
    NSString *imageUrl = kEmptyString;
    if (![Pet2ShareUser current].selectedPet)
    {
        imageUrl = [Pet2ShareUser current].person.profilePictureUrl;
        _profileId = [Pet2ShareUser current].identifier;
        _isPostedByPet = NO;
    }
    else
    {
        imageUrl = [Pet2ShareUser current].selectedPet.profilePictureUrl;
        _profileId = [Pet2ShareUser current].selectedPet.identifier;
        _isPostedByPet = YES;
    }
    [service loadImage:imageUrl completion:^(UIImage *image) {
        self.avatarImageView.image = image ?: [UIImage imageNamed:@"img-avatar"];
    }];
    
    // Set textview placeholder
    self.textView.placeholder = NSLocalizedString(@"Write Something...", @"");
    self.textView.textColor = [AppColorScheme darkGray];
    self.textView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    self.textView.inputAccessoryView = [self createCustomToolbar];
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.textView resignFirstResponder];
}

#pragma mark - 
#pragma mark Private Instance Methods

- (UIToolbar *)createCustomToolbar
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    fixedSpace.width = 10.0f;
    
    if (!self.remainCharacterLabels)
    {
        _remainCharacterLabels = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, kToolbarHeight)];
        _remainCharacterLabels.text = NSLocalizedString(@"300 Characters", @"");
        _remainCharacterLabels.textAlignment = NSTextAlignmentRight;
        _remainCharacterLabels.font = [UIFont systemFontOfSize:12.0f weight:UIFontWeightLight];
        _remainCharacterLabels.textColor = [AppColorScheme lightGray];
        _remainCharacterLabels.userInteractionEnabled = NO;
    }
    UIBarButtonItem *labelBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.remainCharacterLabels];
    
    if (!self.postBtn)
    {
        _postBtn = [[RoundCornerButton alloc] initWithFrame:CGRectMake(0.0f, 4.0f, 80.0f, 32.0f)];
        _postBtn.activityPosition = Center;
        _postBtn.layer.backgroundColor = [AppColorScheme darkBlueColor].CGColor;
        _postBtn.layer.cornerRadius = 3.0f;
        _postBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
        [_postBtn setTitle:NSLocalizedString(@"Post", @"") forState:UIControlStateNormal];
        [_postBtn setTitle:NSLocalizedString(@"Post", @"") forState:UIControlStateHighlighted];
        [_postBtn addTarget:self action:@selector(postBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    }

    UIBarButtonItem *postBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.postBtn];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, kToolbarHeight)];
    toolbar.items = [NSArray arrayWithObjects:flexibleSpace, labelBtnItem, fixedSpace, postBtnItem, nil];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    return toolbar;
}

- (void)updateRemainCharactersLabel
{
    NSInteger remainingChar = _remainCharacters > 0 ? _remainCharacters : 0;
    if (remainingChar == 1) self.remainCharacterLabels.text = [NSString stringWithFormat:@"%ld Characters", (long)remainingChar];
    else self.remainCharacterLabels.text = [NSString stringWithFormat:@"%ld Characters", (long)remainingChar];
    [self.remainCharacterLabels reloadInputViews];
}

#pragma mark - 
#pragma mark Events

- (IBAction)closeBtnTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postBtnTapped:(id)sender
{
    Pet2ShareService *service = [Pet2ShareService new];
    [service addPost:self postDescription:self.textView.text postedBy:_profileId isPostByPet:_isPostedByPet];
}

#pragma mark -
#pragma mark <UITextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < kPostMaxCharacters) return YES;
    else return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _remainCharacters = kPostMaxCharacters - textView.text.length;
    [self updateRemainCharactersLabel];
}

#pragma mark -
#pragma mark <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    [self.postBtn hideActivityIndicator];
    
    if ([self.delegate respondsToSelector:@selector(didPost)])
        [self.delegate didPost];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [self.postBtn hideActivityIndicator];
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

@end