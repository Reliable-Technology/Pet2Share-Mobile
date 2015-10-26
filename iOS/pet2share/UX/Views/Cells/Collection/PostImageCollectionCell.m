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

@interface PostImageCollectionCell ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;


@end

@implementation PostImageCollectionCell

static CGFloat const kCellHeight            = 298.0f;
static CGFloat const kTextLeftPadding       = 17.0f;
static CGFloat const kTextRightPadding      = 20.0f;
static CGFloat const kTextViewHeight        = 79.0f;
static CGFloat const kTextViewFontSize      = 13.0f;
static CGFloat const kBottomSpacing         = 16.0f;

+ (CGFloat)defaultHeight
{
    return 298.0f;
}

+ (CGFloat)heightByText:(NSString *)text withImageHeight:(CGFloat)imageHeight itemWidth:(CGFloat)itemWidth
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

- (void)loadDataWithImageUrl:(NSString *)imgUrl
             descriptionText:(NSString *)descriptionText
{
    Pet2ShareService *service = [Pet2ShareService new];
    [service loadImage:imgUrl aspectRatio:Square completion:^(UIImage *image) {
        self.postImageView.image = image;
    }];

    self.descriptionTxtView.text = descriptionText;
    self.descriptionTxtView.font = [UIFont systemFontOfSize:kTextViewFontSize weight:UIFontWeightRegular];
    self.descriptionTxtView.textColor = [AppColorScheme darkGray];
}

- (void)awakeFromNib
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.descriptionTxtView.textContainerInset = UIEdgeInsetsZero;
    [Graphics dropShadow:self shadowOpacity:0.5f shadowRadius:0.5f offset:CGSizeZero];
}
@end
