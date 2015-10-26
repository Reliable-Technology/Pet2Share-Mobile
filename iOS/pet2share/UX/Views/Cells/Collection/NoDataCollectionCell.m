//
//  NoDataCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/20/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "NoDataCollectionCell.h"
#import "Graphics.h"

@interface NoDataCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation NoDataCollectionCell

+ (CGFloat)height
{
    return 50.0f;
}

- (void)awakeFromNib
{
    [Graphics dropShadow:self shadowOpacity:0.5f shadowRadius:0.5f offset:CGSizeZero];
}

- (void)load:(NSString *)text
{
    self.noDataLabel.text = text;
}

@end
