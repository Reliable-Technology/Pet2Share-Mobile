//
//  CommentCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CommentCollectionCell.h"
#import "Pet2ShareService.h"
#import "CircleImageView.h"
#import "Utils.h"
#import "Graphics.h"

@interface CommentCollectionCell () <Pet2ShareServiceCallback>
{
    NSInteger _commentBy;
    NSInteger _commentId;
}

@property (weak, nonatomic) IBOutlet CircleImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) id<CellButtonDelegate> delegate;

@end

@implementation CommentCollectionCell

static CGFloat const kCellHeight            = 100.0f;
static CGFloat const kTextLeftPadding       = 72.0f;
static CGFloat const kTextRightPadding      = 20.0f;
static CGFloat const kTextViewHeight        = 46.0f;
static CGFloat const kTextViewFontSize      = 13.0f;
static CGFloat const kBottomSpacing         = 16.0f;

+ (CGFloat)defaultHeight
{
    return 100.0f;
}

+ (CGFloat)heightByText:(NSString *)text itemWidth:(CGFloat)itemWidth
{
    CGFloat cellHeight = kCellHeight;
    CGSize textSize = [Utils findHeightForText:text
                                   havingWidth:itemWidth-kTextLeftPadding-kTextRightPadding
                                       andFont:[UIFont systemFontOfSize:kTextViewFontSize weight:UIFontWeightRegular]];
    
    // DEBUG_SIZE("TextView Frame ", textSize);
    
    if (textSize.height < kTextViewHeight) cellHeight = textSize.height+(kCellHeight-kTextViewHeight)+kBottomSpacing/2;
    else cellHeight = textSize.height+(kCellHeight-kTextViewHeight)+kBottomSpacing;
    
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
                   commentId:(NSInteger)commentId
                   commentBy:(NSInteger)commentBy
                  headerText:(NSString *)headerText
             descriptionText:(NSString *)descriptionText
                  statusText:(NSString *)statusText
{
    if (sessionImage)
    {
        self.imageView.image = sessionImage;
    }
    else
    {
        Pet2ShareService *service = [Pet2ShareService new];
        self.imageView.image = [UIImage imageNamed:placeHolderImgName];
        [service loadImage:imgUrl aspectRatio:Square completion:^(UIImage *image) {
            self.imageView.image = image ?: [UIImage imageNamed:placeHolderImgName];
        }];
    }
    
    self.headerLbl.text = headerText;
    self.descriptionTxtView.text = descriptionText;
    self.descriptionTxtView.font = [UIFont systemFontOfSize:kTextViewFontSize weight:UIFontWeightRegular];
    self.descriptionTxtView.textColor = [AppColorScheme darkGray];
    self.statusLbl.text = statusText;
    
    self.delegate = delegate;
    _commentBy = commentBy; _commentId = commentId;
    if (commentBy == [Pet2ShareUser current].identifier)
    {
        self.deleteBtn.hidden = NO;
    }
    else
    {
        self.deleteBtn.hidden = YES;
    }
}

- (void)deleteBtnTapped:(id)sender
{
    [Graphics promptAlert:nil
                  message:NSLocalizedString(@"Do you want to delete this comment?", @"")
                     type:NormalAlert
                       ok:^(SIAlertView *alert) {
                           Pet2ShareService *service = [Pet2ShareService new];
                           [service deleteCommentByUser:self commentId:_commentId userId:_commentBy];
                       } cancel:^(SIAlertView *alert) {
                           return;
                       }];
}

#pragma mark - <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    if ([self.delegate respondsToSelector:@selector(mainButtonTapped:)])
    {
        [self.delegate mainButtonTapped:self.deleteBtn];
    }
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    [Graphics alert:NSLocalizedString(@"Error", @"") message:errorMessage.message type:ErrorAlert];
}

@end
