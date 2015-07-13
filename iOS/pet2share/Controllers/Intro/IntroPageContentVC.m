//
//  IntroPageContentVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "IntroPageContentVC.h"

@interface IntroPageContentVC ()

@property (strong, nonatomic) NSString *introTitle;
@property (strong, nonatomic) NSString *introSubTitle;
@property (strong, nonatomic) NSString *introBgImageName;

@property (weak, nonatomic) IBOutlet SpringImageView *backgroundImgView;
@property (weak, nonatomic) IBOutlet SpringLabel *titleLbl;
@property (weak, nonatomic) IBOutlet SpringLabel *subtitleLbl;

@end

@implementation IntroPageContentVC

#pragma mark - Life Cycle

- (id)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle bgImageName:(NSString *)imageName
{
    if ((self = [super initWithNibName:@"IntroPageContentVC" bundle:nil]))
    {
        _introTitle = title;
        _introSubTitle = subTitle;
        _introBgImageName = imageName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImgView.image = [UIImage imageNamed:self.introBgImageName];
    self.titleLbl.text = self.introTitle;
    self.subtitleLbl.text = [NSString stringWithFormat:@"%@\n\n", self.introSubTitle];
    
    // TODO: Analytics
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the labels with animation
    [self.titleLbl animate];
    [self.subtitleLbl animate];
}

- (void)dealloc
{
    TRACE_HERE;
    self.introTitle = nil;
    self.introSubTitle = nil;
    self.introBgImageName = nil;
    self.backgroundImgView = nil;
}

@end
