//
//  FavoritesVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "FavoritesVC.h"
#import "AppColor.h"

@interface FavoritesVC  ()

@property (weak, nonatomic) IBOutlet SpringView *constructionView;

@end

@implementation FavoritesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        self.constructionView.hidden = NO;
        self.constructionView.animation = @"zoomIn";
        self.constructionView.curve = @"spring";
        self.constructionView.duration = 1.0f;
        [self.constructionView animate];
    });
}

@end
