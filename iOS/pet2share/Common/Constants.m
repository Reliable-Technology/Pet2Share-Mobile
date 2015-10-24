//
//  Constants.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Constants.h"

#pragma mark - Commons

NSString * const kEmptyString                   = @"";
CGFloat const kBarButtonWidth                   = 32.0f;
CGFloat const kBarButtonHeight                  = 32.0f;
NSString * const kLogoTypeface                  = @"LobsterTwo-Bold";
NSInteger const kcenturyInSeconds               = 3154000000;
NSInteger const kDescriptionMaxCharacters       = 1000;
NSInteger const kPostMaxCharacters              = 300;
NSInteger const kCacheTimeOut                   = 60*3;
NSInteger const kImageCacheTimeOut              = 60*60*24;
NSString * const kUserSessionAvatarImage        = @"useravatarsessionimage";
NSString * const kPetSessionAvatarImage         = @"petavatarimage";
NSInteger const kNumberOfPostPerPage            = 10;
CGFloat const kImageCompressionRatio            = 0.5;

#pragma mark - Segues

NSString * const kMainStoryboard                = @"Pet2Share";
NSString * const kSegueIntroPages               = @"intropages";
NSString * const kSegueSignUp                   = @"signup";
NSString * const kSegueLogin                    = @"login";
NSString * const kSegueProfile                  = @"profile";
NSString * const kSegueLoginContainer           = @"logincontainer";
NSString * const kSegueRegisterContainer        = @"registercontainer";
NSString * const kSegueDashboard                = @"dashboard";
NSString * const kSeguePostsCollection          = @"postscollection";
NSString * const kSegueMainView                 = @"mainview";
NSString * const kSegueFeedCollection           = @"feedcollection";
NSString * const kSegueProfileSelection         = @"profileselection";
NSString * const kSegueNewPost                  = @"newpost";
NSString * const kSegueComment                  = @"comment";
NSString * const kSegueCommentContainer         = @"commentcontainer";
NSString * const kSegueEditProfile              = @"editprofile";
NSString * const kSeguePetProfile               = @"petprofile";
NSString * const kSegueAddEditPetProfile        = @"addeditpetprofile";
NSString * const kSegueShowCamera               = @"showcamera";
NSString * const kSeguePostDetail               = @"postdetail";
NSString * const kSeguePostDetailContainer      = @"postdetailcontainer";

#pragma mark - Date Format

NSString * const kFormatDate                    = @"yyyy-MM-dd 00:00:00";
NSString * const kFormatDateTime                = @"yyyy-MM-dd HH:mm:00.000";
NSString * const kFormatDateTimeShort           = @"yyyy-MM-dd HH:mm:ss";
NSString * const kFormatDateTimeLong            = @"yyyy-MM-dd HH:mm:ss.SSS";
NSString * const kFormatDateUTC                 = @"yyyy-MM-dd HH:mm:ss ZZZ";
NSString * const kFormatDayOfWeekWithDate       = @"EEE, dd MMM";
NSString * const kFormatDayOfWeekWithDateTime   = @"EEE, dd MMM hh:mm a";
NSString * const kFormatDayMonthShort           = @"dd MMM";
NSString * const kFormatMonthYearShort          = @"MMM, yyyy";
NSString * const kFormatDayOfWeekShort          = @"EEE";
NSString * const kFormatDayOfWeekLong           = @"EEEE";
NSString * const kFormatDateUS                  = @"MM/dd/yyyy";

