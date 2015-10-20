//
//  PostTextCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PostTextCollectionCell.h"
#import "Utils.h"
#import "Graphics.h"
#import "Pet2ShareService.h"
#import "CircleImageView.h"

@interface PostTextCollectionCell ()

@property (weak, nonatomic) IBOutlet CircleImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *primaryTxtLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondaryTxtLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtView;

@end

@implementation PostTextCollectionCell

static CGFloat const kCellHeight            = 170.0f;
static CGFloat const kTextPadding           = 20.0f;
static CGFloat const kTextViewHeight        = 78.0f;
static CGFloat const kTextViewFontSize      = 13.0f;
static CGFloat const kBottomSpacing         = 16.0f;

+ (CGFloat)defaultHeight
{
    return 150.f;
}

+ (CGFloat)heightByText:(NSString *)text itemWidth:(CGFloat)itemWidth
{
    CGFloat cellHeight = kCellHeight;
    CGSize textSize = [Utils findHeightForText:text
                                   havingWidth:itemWidth-kTextPadding*2
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
}

- (void)loadDataWithImageUrl:(NSString *)imgUrl
        placeHolderImageName:(NSString *)placeHolderImgName
                 primaryText:(NSString *)primaryText
               secondaryText:(NSString *)secondaryText
             descriptionText:(NSString *)descriptionText
                  statusText:(NSString *)statusText
{
    Pet2ShareService *service = [Pet2ShareService new];
    self.imageView.image = [UIImage imageNamed:placeHolderImgName];
    [service loadImage:imgUrl completion:^(UIImage *image) {
        self.imageView.image = image ?: [UIImage imageNamed:placeHolderImgName];
    }];
    
    self.primaryTxtLbl.text = primaryText;
    self.secondaryTxtLbl.text = secondaryText;
    self.descriptionTxtView.text = descriptionText;
    self.descriptionTxtView.font = [UIFont systemFontOfSize:kTextViewFontSize weight:UIFontWeightRegular];
    self.descriptionTxtView.textColor = [AppColorScheme darkGray];
    
    self.statusLbl.text = statusText;
}

@end
