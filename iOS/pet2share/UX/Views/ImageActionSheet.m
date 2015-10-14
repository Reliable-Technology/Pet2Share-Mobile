//
//  ImageActionSheet.m
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ImageActionSheet.h"
#import "AppColorScheme.h"

@implementation ImageActionSheet

+ (NSString *)getLabel:(NSInteger)imageActionButton
{
    switch (imageActionButton)
    {
        case IMAGE_BUTTON_UPLOADIMAGE:
            return NSLocalizedString(@"Upload Image", @"");
        case IMAGE_BUTTON_TAKEPICTURE:
            return NSLocalizedString(@"Take Picture", @"");
    }
    
    return kEmptyString;
}

#pragma mark - 
#pragma mark Life Cycle

// Overload to be able to pass width button for wider titles
-(id)initWithTitle:(NSString *)title
          delegate:(__weak id<ImageActionSheetDelegate>)delegate
  availableButtons:(NSArray *)availableButtons
 cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self = [super init];
    
    if (self)
    {
        responseDelegate = delegate;
        neededButtons = availableButtons;
        
        alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        for(int i = 0; i < neededButtons.count; i++)
        {
            NSInteger buttonValue = [[neededButtons objectAtIndex: i] intValue];
            NSString *buttonText = [ImageActionSheet getLabel: buttonValue];
            
            [alertController addAction:[UIAlertAction actionWithTitle: buttonText
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [self actionSheet: self clickedButtonAtIndex: buttonValue];
                                                              }]];
        }
        
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction *action) {
                                                              [self actionSheet: self clickedButtonAtIndex: self.cancelButtonIndex];
                                                          }]];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(dismissActionSheet) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    
    return self;
}

- (void)showInViewController:(UIViewController *)viewController
{
    [viewController presentViewController: alertController animated: YES completion: nil];
}

- (void)dismissActionSheet
{
    [alertController dismissViewControllerAnimated: NO completion: nil];
}

- (void)actionSheet:(ImageActionSheet *)sender clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([responseDelegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
    {
        [responseDelegate actionSheet: self clickedButtonAtIndex: buttonIndex];
    }
}

- (NSInteger) cancelButtonIndex
{
    return -1;
}

@end