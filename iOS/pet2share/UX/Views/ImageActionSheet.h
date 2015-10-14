//
//  ImageActionSheet.h
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ImageActionButton)
{
    IMAGE_BUTTON_UPLOADIMAGE,
    IMAGE_BUTTON_TAKEPICTURE
};

@class ImageActionSheet;

@protocol ImageActionSheetDelegate <NSObject>

@required
-(void)actionSheet:(ImageActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ImageActionSheet : NSObject
{
    UIAlertController *alertController;
    NSArray *neededButtons;
    __weak id<ImageActionSheetDelegate> responseDelegate;
}

- (id)initWithTitle:(NSString *)title
           delegate:(__weak id<ImageActionSheetDelegate>)delegate
   availableButtons:(NSArray *)availableButtons
  cancelButtonTitle:(NSString *)cancelButtonTitle;

- (void)showInViewController: (UIViewController *)viewController;
- (void)dismissActionSheet;

+ (NSString *)getLabel:(NSInteger)imageActionButton;

@property(nonatomic, readonly) NSInteger cancelButtonIndex;

@end
