
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
#import "Pet2ShareService.h"
#import "AppColor.h"
#import "Utils.h"
#import "Graphics.h"
#import "RoundCornerButton.h"
#import "NSString+URLEncoding.h"

static CGFloat const kToolbarHeight = 44.0f;

@interface NewPostVC () <UITextViewDelegate, Pet2ShareServiceCallback, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSInteger _remainCharacters;
    NSInteger _profileId;
    BOOL _isPostedByPet;
    CGRect _previousRect;
}

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *textView;
@property (strong, nonatomic) UILabel *remainCharacterLabels;
@property (strong, nonatomic) RoundCornerButton *postBtn;
@property (strong, nonatomic) NSString *profileName;

- (IBAction)closeBtnTapped:(id)sender;

@end

@implementation NewPostVC

#pragma mark - Life Cycle

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
    
    Pet *selectedPet = [Pet2ShareUser current].selectedPet;
    if (self.pet) selectedPet = self.pet;
    
    UIImage *sessionAvatarImage;
    
    // Load Profile Image
    if (!selectedPet)
    {
        _profileId = [Pet2ShareUser current].identifier;
        _isPostedByPet = NO;
        _profileName = [NSString stringWithFormat:@"%@ %@",
                        [Pet2ShareUser current].person.firstName, [Pet2ShareUser current].person.lastName];
        sessionAvatarImage = [Pet2ShareUser current].getUserSessionAvatarImage;
        
        if (sessionAvatarImage)
        {
            self.avatarImageView.image = sessionAvatarImage;
        }
        else
        {
            [[Pet2ShareService new] loadImage:[Pet2ShareUser current].person.profilePictureUrl aspectRatio:Square completion:^(UIImage *image) {
                self.avatarImageView.image = image ?: [UIImage imageNamed:@"img-avatar"];
            }];
        }
    }
    else
    {
        _profileId = selectedPet.identifier;
        _isPostedByPet = YES;
        _profileName = selectedPet.name ?: kEmptyString;
        
        UIImage *petSessionImage = [[Pet2ShareUser current] getPetSessionAvatarImage:_profileId];
        if (petSessionImage)
        {
            self.avatarImageView.image = petSessionImage;
        }
        else
        {
            [[Pet2ShareService new] loadImage:[Pet2ShareUser current].selectedPet.profilePictureUrl aspectRatio:Square completion:^(UIImage *image) {
                self.avatarImageView.image = image ?: [UIImage imageNamed:@"img-avatar"];
            }];
        }
    }
   
    // Set textview placeholder
    self.textView.placeholder = [NSString stringWithFormat:@"%@: %@", self.profileName, NSLocalizedString(@"Write Something...", @"")];
    self.textView.textColor = [AppColorScheme darkGray];
    self.textView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    self.textView.inputAccessoryView = [self createCustomToolbar];
    self.textView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
    if (self.postImage)
    {
        CGSize size = [Graphics getImageViewSizeForImage:self.postImage
                                            constraintTo:self.textView.frame.size.width-10];
        NSString *currentText = self.textView.text;

        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:kEmptyString];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = self.postImage;
        textAttachment.bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attrString replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:attrStringWithImage];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:currentText]];
        
        self.textView.attributedText = attrString;
        self.textView.textColor = [AppColorScheme darkGray];
        self.textView.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightRegular];
    }
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

#pragma mark - Private Instance Methods

- (UIToolbar *)createCustomToolbar
{
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    fixedSpace.width = 10.0f;
    
    // Camera Button
    UIButton *cameraBtn = [self createIconBarButton:CGRectMake(0.0f, 0.0f, 20.0f, 18.0f) iconName:@"icon-camera-small"];
    [cameraBtn addTarget:self action:@selector(cameraBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cameraBtnItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
    
    // Image Button
    UIButton *imageBtn = [self createIconBarButton:CGRectMake(0.0f, 0.0f, 20.0f, 18.0f) iconName:@"icon-image-small"];
    [imageBtn addTarget:self action:@selector(imageBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *imageBtnItem = [[UIBarButtonItem alloc] initWithCustomView:imageBtn];
    
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
    toolbar.items = [NSArray arrayWithObjects:cameraBtnItem, fixedSpace, imageBtnItem, flexibleSpace, labelBtnItem, postBtnItem, nil];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    
    return toolbar;
}

- (UIButton *)createIconBarButton:(CGRect)frame iconName:(NSString *)iconName
{
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    iconBtn.bounds = CGRectMake(0.0f, 0.0f, 20.0f, 18.0f);
    [iconBtn setBackgroundImage:[[UIImage imageNamed:iconName]
                                   imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    iconBtn.tintColor = [AppColorScheme lightGray];
    [iconBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    return iconBtn;
}

- (void)updateRemainCharactersLabel
{
    NSInteger remainingChar = _remainCharacters > 0 ? _remainCharacters : 0;
    if (remainingChar == 1) self.remainCharacterLabels.text = [NSString stringWithFormat:@"%ld Characters", (long)remainingChar];
    else self.remainCharacterLabels.text = [NSString stringWithFormat:@"%ld Characters", (long)remainingChar];
    [self.remainCharacterLabels reloadInputViews];
}

#pragma mark - Events

- (IBAction)closeBtnTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraBtnTapped:(id)sender
{
    fTRACE(@"Sender: %@", sender);
    
    @try
    {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.transitioningDelegate = self.transitionZoom;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Camera is not available", @"")
                   type:ErrorAlert];
    };
}

- (void)imageBtnTapped:(id)sender
{
    fTRACE(@"Sender: %@", sender);
    
    @try
    {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.transitioningDelegate = self.transitionZoom;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s : Exception: %@", __func__, [exception description]);
        [Graphics alert:NSLocalizedString(@"Error", @"")
                message:NSLocalizedString(@"Photo Library is not available", @"")
                   type:ErrorAlert];
    };
}

- (void)postBtnTapped:(id)sender
{
    [self.postBtn showActivityIndicator];
    
    Pet2ShareService *service = [Pet2ShareService new];
    NSString *description = [[NSMutableString alloc] initWithString:self.textView.text];
    description = [description stringByReplacingOccurrencesOfString:@"\n" withString:kEmptyString];
    NSString *encodedDescription = [description stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (!self.postImage)
    {
        [service addPost:self postDescription:encodedDescription
                postedBy:_profileId isPostByPet:_isPostedByPet];
    }
    else
    {
        encodedDescription = [encodedDescription substringWithRange:NSMakeRange(9, [encodedDescription length]-9)];
        [service addPhotoPost:self
                  description:encodedDescription postedBy:_profileId isPostByPet:_isPostedByPet
                        image:self.postImage fileName:postUserImage(_profileId)];
    }
}

#pragma mark - <Pet2ShareServiceCallback>

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

#pragma mark - <UITextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < kPostMaxCharacters) return YES;
    else return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _remainCharacters = kPostMaxCharacters - textView.text.length;
    [self updateRemainCharactersLabel];
    
    if ([textView.text isEqualToString:kEmptyString]) self.postImage = nil;
    
    fTRACE("Text: %@", textView.text);
}

#pragma mark - <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    fTRACE("Info: %@", info);
    
    /** Info Example
     * UIImagePickerControllerCropRect = "NSRect: {{0, 0}, {2668, 1772}}";
     * UIImagePickerControllerEditedImage = "<UIImage: 0x7fa49f896350> size {748, 496} orientation 0 scale 1.000000";
     * UIImagePickerControllerMediaType = "public.image";
     * UIImagePickerControllerOriginalImage = "<UIImage: 0x7fa49f895ec0> size {2668, 1772} orientation 0 scale 1.000000";
     * UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=D77460CE-4855-4A54-BE4D-5C0A84C7742B&ext=JPG";
     */
    
    self.postImage = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end