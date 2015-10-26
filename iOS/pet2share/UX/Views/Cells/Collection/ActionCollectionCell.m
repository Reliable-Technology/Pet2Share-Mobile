//
//  ActionCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 10/24/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "ActionCollectionCell.h"
#import "Graphics.h"

@interface ActionCollectionCell ()

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end

@implementation ActionCollectionCell

+ (CGFloat)height
{
    return 50.0f;
}

- (void)awakeFromNib
{
    [Graphics dropShadow:self shadowOpacity:0.5f shadowRadius:0.5f offset:CGSizeZero];
    [self.actionBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setButtonText:(NSString *)text
{
    [self.actionBtn setTitle:text forState:UIControlStateNormal];
    [self.actionBtn setTitle:text forState:UIControlStateHighlighted];
}

- (void)buttonTapped:(id)sender
{
    if ([self.buttonDelegate respondsToSelector:@selector(mainButtonTapped:)])
    {
        [self.buttonDelegate mainButtonTapped:sender];
    }
}

@end
