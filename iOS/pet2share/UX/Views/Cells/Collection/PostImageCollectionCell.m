//
//  PostImageCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/22/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PostImageCollectionCell.h"
#import "Utils.h"
#import "Graphics.h"
#import "Pet2ShareService.h"
#import "CircleImageView.h"

@interface PostImageCollectionCell () <Pet2ShareServiceCallback>
{
    NSInteger _postId;
    NSInteger _isPostById;
    BOOL _isPostByPet;
}

@property (weak, nonatomic) IBOutlet CircleImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *primaryTxtLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondaryTxtLbl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) id<CellButtonDelegate> delegate;

@end

@implementation PostImageCollectionCell

static CGFloat const kCellHeight            = 480.0f;
static CGFloat const kTextLeftPadding       = 17.0f;
static CGFloat const kTextRightPadding      = 20.0f;
static CGFloat const kTextViewHeight        = 79.0f;
static CGFloat const kTextViewFontSize      = 13.0f;
static CGFloat const kBottomSpacing         = 20.0f;
static CGFloat const kImageSpacing          = 20.0f;
static CGFloat const kHeaderHeight          = 60.0f;

+ (CGFloat)defaultHeight
{
    return 480.f;
}

+ (CGFloat)heightByText:(NSString *)text itemWidth:(CGFloat)itemWidth
{
    CGFloat cellHeight = kCellHeight;
    CGSize textSize = [Utils findHeightForText:text
                                   havingWidth:itemWidth-kTextLeftPadding-kTextRightPadding
                                       andFont:[UIFont systemFontOfSize:kTextViewFontSize weight:UIFontWeightRegular]];
    
    // DEBUG_SIZE("TextView Frame ", textSize);
    if (textSize.height < kTextViewHeight) cellHeight = textSize.height+kHeaderHeight+kBottomSpacing/2;
    else cellHeight = textSize.height+kHeaderHeight+kBottomSpacing;
    
    CGSize size = [Graphics getDeviceSize];
    CGFloat actualImageWidth = size.width-2*kImageSpacing;
    CGFloat actualImageHeight = ceilf(actualImageWidth*12/16);
    
    cellHeight += actualImageHeight;
    
    // fTRACE(@"Cell Height: %.f", cellHeight);
    
    return cellHeight;
}

- (void)awakeFromNib
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.descriptionTxtView.textContainerInset = UIEdgeInsetsZero;
    [Graphics dropShadow:self shadowOpacity:0.5f shadowRadius:0.5f offset:CGSizeZero];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadDataWithImageUrl:(NSString *)imgUrl
        placeHolderImageName:(NSString *)placeHolderImgName
                sessionImage:(UIImage *)sessionImage
                    delegate:(id<CellButtonDelegate>)delegate
                      postId:(NSInteger)postId
                  isPostById:(NSInteger)isPostById
                 isPostByPet:(BOOL)isPostByPet
                postImageUrl:(NSString *)postImgUrl
                 primaryText:(NSString *)primaryText
               secondaryText:(NSString *)secondaryText
             descriptionText:(NSString *)descriptionText
                  statusText:(NSString *)statusText
{
    if (sessionImage)
    {
        self.avatarImageView.image = sessionImage;
    }
    else
    {
        Pet2ShareService *service = [Pet2ShareService new];
        self.avatarImageView.image = [UIImage imageNamed:placeHolderImgName];
        [service loadImage:imgUrl aspectRatio:Square completion:^(UIImage *image) {
            self.avatarImageView.image = image ?: [UIImage imageNamed:placeHolderImgName];
        }];
    }
        
    Pet2ShareService *service = [Pet2ShareService new];
    self.postImageView.image = [UIImage new];
    [service loadImage:postImgUrl aspectRatio:Landscape completion:^(UIImage *image) {
        self.postImageView.image = image ?: [UIImage new];
    }];
    
    self.primaryTxtLbl.text = primaryText;
    self.secondaryTxtLbl.text = secondaryText;
    self.descriptionTxtView.text = descriptionText;
    self.descriptionTxtView.font = [UIFont systemFontOfSize:kTextViewFontSize weight:UIFontWeightRegular];
    self.descriptionTxtView.textColor = [AppColorScheme darkGray];
    self.statusLbl.text = statusText;
    
    Pet2ShareUser *currUser = [Pet2ShareUser current];
    self.delegate = delegate;
    _postId = postId; _isPostById = isPostById; _isPostByPet = isPostByPet;
    
    if (isPostByPet)
    {
        if (isPostById == currUser.selectedPet.identifier)
            self.deleteBtn.hidden = NO;
        else
            self.deleteBtn.hidden = YES;
    }
    else
    {
        if (isPostById == currUser.identifier)
            self.deleteBtn.hidden = NO;
        else
            self.deleteBtn.hidden = YES;
    }
}

- (void)deleteBtnTapped:(id)sender
{
    [Graphics promptAlert:nil
                  message:NSLocalizedString(@"Do you want to delete this post?", @"")
                     type:NormalAlert
                       ok:^(SIAlertView *alert) {
                           Pet2ShareService *service = [Pet2ShareService new];
                           [service deletePostByPoster:self postId:_postId postedById:_isPostById isPostedByPet:_isPostByPet];
                       } cancel:^(SIAlertView *alert) {
                           return;
                       }];
}

#pragma mark - <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    if ([self.delegate respondsToSelector:@selector(actionButtonTapped:identifier:)])
    {
        [self.delegate actionButtonTapped:self.deleteBtn identifier:_postId];
    }
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

@end