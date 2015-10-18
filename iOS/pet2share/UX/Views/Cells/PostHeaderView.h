//
//  PostHeaderView.h
//  pet2share
//
//  Created by Tony Kieu on 10/17/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostHeaderDelegate <NSObject>

@optional;
- (void)performActionOnTap:(id)sender;

@end

@interface PostHeaderView : UIView

@property (nonatomic, weak) id<PostHeaderDelegate> delegate;

+ (CGFloat)height;
- (void)updateHeaderView:(NSString *)imageUrl postedName:(NSString *)postedName postedDate:(NSDate *)postedDate;

@end
