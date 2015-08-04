//
//  PFErrors.h
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    TBParseError_AccountAlreadyLinked               = 208,  // An existing account already linked to another user.
    TBParseError_CacheMiss                          = 120,  // The results were not found in the cache.
    TBParseError_CommandUnavailable                 = 108,  // Tried to access a feature only available internally.
    TBParseError_ConnectionFailed                   = 100,  // The connection to the Parse servers failed.
    TBParseError_DuplicateValue                     = 137,  // A unique field was given a value that is already taken.
    TBParseError_ExceededQuota                      = 140,  // Exceeded an application quota. Upgrade to resolve.
    TBParseError_FacebookAccountAlreadyLinked       = 208,  // An existing Facebook account already linked to another user.
    TBParseError_FacebookIdMissing                  = 250,  // Facebook id missing from request
    TBParseError_FacebookInvalidSession             = 251,  // Invalid Facebook session
    TBParseError_FileDeleteFailure                  = 153,  // Fail to delete file.
    TBParseError_IncorrectType                      = 111,  // Field set to incorrect type.
    TBParseError_InternalServer                     = 1,    // Internal server error. No information available.
    TBParseError_InvalidACL                         = 123,  // Invalid ACL. An ACL with an invalid format was saved. This should not happen if you use PFACL.
    TBParseError_InvalidChannelName                 = 112,  // Invalid channel name. A channel name is either an empty string or contains only a-zA-Z0-9_ characters and starts with a letter.
    TBParseError_InvalidClassName                   = 103,  // Missing or invalid classname. Classnames are case-sensitive. They must start with a letter, and a-zA-Z0-9_ are the only valid characters.
    TBParseError_InvalidDeviceToken                 = 114,  // Invalid device token.
    TBParseError_InvalidEmailAddress                = 125,  // The email address was invalid.
    TBParseError_InvalidFileName                    = 122,  // Invalid file name. A file name contains only a-zA-Z0-9_. characters and is between 1 and 36 characters.
    TBParseError_InvalidImageData                   = 150,  // Fail to convert data to image.
    TBParseError_InvalidJSON                        = 107,  // Malformed json object. A json dictionary is expected.
    TBParseError_InvalidKeyName                     = 105,  // Invalid key name. Keys are case-sensitive. They must start with a letter, and a-zA-Z0-9_ are the only valid characters.
    TBParseError_InvalidLinkedSession               = 251,  // Invalid linked session
    TBParseError_InvalidNestedKey                   = 121,  // Keys in NSDictionary values may not include '$' or '.'.
    TBParseError_InvalidPointer                     = 106,  // Malformed pointer. Pointers must be arrays of a classname and an object id.
    TBParseError_InvalidProductIdentifier           = 146,  // The product identifier is invalid
    TBParseError_InvalidPurchaseReceipt             = 144,  // Product purchase receipt is invalid
    TBParseError_InvalidQuery                       = 102,  // You tried to find values matching a datatype that doesn't support exact database matching, like an array or a dictionary.
    TBParseError_InvalidRoleName                    = 139,  // Role's name is invalid.
    TBParseError_InvalidServerResponse              = 148,  // The Apple server response is not valid
    TBParseError_LinkedIdMissing                    = 250,  // Linked id missing from request
    TBParseError_MissingObjectId                    = 104,  // Missing object id.
    TBParseError_ObjectNotFound                     = 101,  // Object doesn't exist, or has an incorrect password.
    TBParseError_ObjectTooLarge                     = 116,  // The object is too large.
    TBParseError_OperationForbidden                 = 119,  // That operation isn't allowed for clients.
    TBParseError_PaymentDisabled                    = 145,  // Payment is disabled on this device
    TBParseError_ProductDownloadFileSystemFailure   = 149,  // Product fails to download due to file system error
    TBParseError_ProductNotFoundInAppStore          = 147,  // The product is not found in the App Store
    TBParseError_PushMisconfigured                  = 115,  // Push is misconfigured. See details to find out how.
    TBParseError_ReceiptMissing                     = 143,  // Product purchase receipt is missing
    TBParseError_Timeout                            = 124,  // The request timed out on the server. Typically this indicates the request is too expensive.
    TBParseError_UnsavedFile                        = 151,  // Unsaved file.
    TBParseError_UserCannotBeAlteredWithoutSession  = 206,  // The user cannot be altered by a client without the session.
    TBParseError_UserCanOnlyBeCreatedThroughSignUp  = 207,  // Users can only be created through sign up
    TBParseError_UserEmailMissing                   = 204,  // The email is missing, and must be specified
    TBParseError_UserEmailTaken                     = 203,  // Email has already been taken
    TBParseError_UserIdMismatch                     = 209,  // User ID mismatch
    TBParseError_UsernameMissing                    = 200,  // Username is missing or empty
    TBParseError_UsernameTaken                      = 202,  // Username has already been taken
    TBParseError_UserPasswordMissing                = 201,  // Password is missing or empty
    TBParseError_UserWithEmailNotFound              = 205,  // A user with the specified email was not found
    TBParseError_ScriptError                        = 141,  // Cloud Code script had an error.
    TBParseError_ValidationError                    = 142   // Cloud Code validation failed.
} TBParseError;

@interface PFErrors : NSObject

+ (NSString *)getParseErrorMessage:(TBParseError)parseError;

@end
