//
//  BaseNavigationVC.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationProtocol.h"
#import "ImageActionSheet.h"

@protocol BaseNavigationProtocol <NSObject>

@optional
- (UIButton *)setupLeftBarButton;
- (UIButton *)setupRightBarButton;
- (void)handleActionButton:(NSInteger)buttonIndex;

@end

@interface BaseNavigationVC : UIViewController

@property (nonatomic, weak) id<BaseNavigationProtocol> baseNavProtocol;

@property (nonatomic, strong) TransitionManager *transitionManager;
@property (nonatomic, strong) TransitionZoom *transitionZoom;

- (void)handleLeftButtonEvent:(id)sender;
- (void)handleRightButtonEvent:(id)sender;
- (void)setLeftBarButtonTitle:(NSString *)text;
- (void)setLeftBarButtonImage:(UIImage *)image;
- (void)setRightBarButtonTitle:(NSString *)text;
- (void)setRightBarButtonImage:(UIImage *)image;
- (void)setupActionSheet:(NSString *)title buttons:(NSArray *)buttons;

@end
