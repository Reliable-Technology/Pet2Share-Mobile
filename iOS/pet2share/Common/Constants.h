//
//  Constants.h
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Commons

/** Degrees to Radians **/
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

#define propertyKeyPath(property) (@""#property)
#define propertyKeyPathLastComponent(property) [[(@""#property) componentsSeparatedByString:@"."] lastObject]

#define avatarUserKey(identifier) [NSString stringWithFormat:@"avatar_user_%ld", identifier]
#define avatarPetKey(identifier) [NSString stringWithFormat:@"avatar_pet_%ld", identifier]

extern NSString * const kEmptyString;
extern CGFloat const kBarButtonWidth;
extern CGFloat const kBarButtonHeight;
extern NSString * const kLogoTypeface;
extern NSInteger const kcenturyInSeconds;
extern NSInteger const kDescriptionMaxCharacters;
extern NSInteger const kCacheTimeOut;
extern NSInteger const kImageCacheTimeOut;
extern NSString * const kTempAvatarImage;

#pragma mark - Segues

extern NSString * const kMainStoryboard;
extern NSString * const kSegueIntroPages;
extern NSString * const kSegueSignUp;
extern NSString * const kSegueLogin;
extern NSString * const kSegueProfile;
extern NSString * const kSegueLoginContainer;
extern NSString * const kSegueRegisterContainer;
extern NSString * const kSegueDashboard;
extern NSString * const kSegueMainView;
extern NSString * const kSegueEditProfile;
extern NSString * const kSeguePetProfile;
extern NSString * const kSegueAddEditPetProfile;
extern NSString * const kSegueShowCamera;
extern NSString * const kSeguePostImage;

#pragma mark - Date Format

extern NSString * const kFormatDate;
extern NSString * const kFormatDateTime;
extern NSString * const kFormatDateTimeShort;
extern NSString * const kFormatDateTimeLong;
extern NSString * const kFormatDateUTC;
extern NSString * const kFormatDayOfWeekWithDate;
extern NSString * const kFormatDayMonthShort;
extern NSString * const kFormatMonthYearShort;
extern NSString * const kFormatDayOfWeekShort;
extern NSString * const kFormatDayOfWeekLong;
extern NSString * const kFormatDateUS;