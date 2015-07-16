//
//  DashboardCollectionCell.m
//  pet2share
//
//  Created by Tony Kieu on 7/15/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DashboardCollectionCell.h"
#import "Graphics.h"
#import "AppColor.h"

@interface DashboardCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation DashboardCollectionCell

- (void)awakeFromNib
{
    NSUInteger pickACat = arc4random_uniform(4) + 1;
    NSString *catFilename = [NSString stringWithFormat:@"img-cat%lu.jpg", (unsigned long)pickACat];
    self.imageView.image = [UIImage imageNamed:catFilename];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.layer.cornerRadius = 3.0f;
}


@end
