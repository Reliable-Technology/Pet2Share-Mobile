//
//  PFErrors.m
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PFErrors.h"

@implementation PFErrors

+ (NSString *)getParseErrorMessage:(TBParseError)parseError
{
    NSString *errorString;
    
    switch (parseError)
    {
        case TBParseError_AccountAlreadyLinked:
            errorString = NSLocalizedString(@"An existing account already linked to another user.", @"");
            break;
        case TBParseError_CacheMiss:
            errorString = NSLocalizedString(@"The results were not found in the cache.", @"");
            break;
        case TBParseError_CommandUnavailable:
            errorString = NSLocalizedString(@"Tried to access a feature only available internally.", @"");
            break;
        case TBParseError_ConnectionFailed:
            errorString = NSLocalizedString(@"The connection to the Parse servers failed.", @"");
            break;
        case TBParseError_ExceededQuota:
            errorString = NSLocalizedString(@"Exceeded an application quota. Upgrade to resolve.", @"");
            break;
        case TBParseError_FileDeleteFailure:
            errorString = NSLocalizedString(@"Fail to delete file.", @"");
            break;
        case TBParseError_IncorrectType:
            errorString = NSLocalizedString(@"Field set to incorrect type.", @"");
            break;
        case TBParseError_InternalServer:
            errorString = NSLocalizedString(@"Internal server error. No information available.", @"");
            break;
        case TBParseError_InvalidACL:
            errorString = NSLocalizedString(@"Invalid ACL. An ACL with an invalid format was saved. This should not happen if you use PFACL.", @"");
            break;
        case TBParseError_InvalidChannelName:
            errorString = NSLocalizedString(@"Invalid channel name. A channel name is either an empty string (the broadcast channel) or contains only a-zA-Z0-9_ characters and starts with a letter.", @"");
            break;
        case TBParseError_InvalidClassName:
            errorString = NSLocalizedString(@"Missing or invalid classname. Classnames are case-sensitive. They must start with a letter, and a-zA-Z0-9_ are the only valid characters.", @"");
            break;
        case TBParseError_InvalidDeviceToken:
            errorString = NSLocalizedString(@"Invalid device token.", @"");
            break;
        case TBParseError_InvalidEmailAddress:
            errorString = NSLocalizedString(@"The email address was invalid.", @"");
            break;
        case TBParseError_InvalidFileName:
            errorString = NSLocalizedString(@"Invalid file name. A file name contains only a-zA-Z0-9_. characters and is between 1 and 36 characters.", @"");
            break;
        case TBParseError_InvalidImageData:
            errorString = NSLocalizedString(@"Fail to convert data to image.", @"");
            break;
        case TBParseError_InvalidJSON:
            errorString = NSLocalizedString(@"Malformed json object. A json dictionary is expected.", @"");
            break;
        case TBParseError_InvalidKeyName:
            errorString = NSLocalizedString(@"Invalid key name. Keys are case-sensitive. They must start with a letter, and a-zA-Z0-9_ are the only valid characters.", @"");
            break;
        case TBParseError_InvalidLinkedSession:
            errorString = NSLocalizedString(@"Invalid linked session.", @"");
            break;
        case TBParseError_InvalidNestedKey:
            errorString = NSLocalizedString(@"Keys in NSDictionary values may not include '$' or '.'.", @"");
            break;
        case TBParseError_InvalidPointer:
            errorString = NSLocalizedString(@"Malformed pointer. Pointers must be arrays of a classname and an object id.", @"");
            break;
        case TBParseError_InvalidProductIdentifier:
            errorString = NSLocalizedString(@"The product identifier is invalid.", @"");
            break;
        case TBParseError_InvalidPurchaseReceipt:
            errorString = NSLocalizedString(@"Product purchase receipt is invalid", @"");
            break;
        case TBParseError_InvalidQuery:
            errorString = NSLocalizedString(@"You tried to find values matching a datatype that doesn't support exact database matching, like an array or a dictionary.", @"");
            break;
        case TBParseError_InvalidRoleName:
            errorString = NSLocalizedString(@"Role's name is invalid.", @"");
            break;
        case TBParseError_InvalidServerResponse:
            errorString = NSLocalizedString(@"The Apple server response is not valid.", @"");
            break;
        case TBParseError_LinkedIdMissing:
            errorString = NSLocalizedString(@"Linked id missing from request", @"");
            break;
        case TBParseError_MissingObjectId:
            errorString = NSLocalizedString(@"Missing object id.", @"");
            break;
        case TBParseError_ObjectNotFound:
            errorString = NSLocalizedString(@"Object doesn't exist, or has an incorrect password.", @"");
            break;
        case TBParseError_ObjectTooLarge:
            errorString = NSLocalizedString(@"The object is too large.", @"");
            break;
        case TBParseError_OperationForbidden:
            errorString = NSLocalizedString(@"That operation isn't allowed for clients.", @"");
            break;
        case TBParseError_PaymentDisabled:
            errorString = NSLocalizedString(@"Payment is disabled on this device.", @"");
            break;
        case TBParseError_ProductDownloadFileSystemFailure:
            errorString = NSLocalizedString(@"Product fails to download due to file system error.", @"");
            break;
        case TBParseError_ProductNotFoundInAppStore:
            errorString = NSLocalizedString(@"The product is not found in the App Store.", @"");
            break;
        case TBParseError_PushMisconfigured:
            errorString = NSLocalizedString(@"Push is misconfigured. See details to find out how.", @"");
            break;
        case TBParseError_ReceiptMissing:
            errorString = NSLocalizedString(@"Push is misconfigured. See details to find out how.", @"");
            break;
        case TBParseError_Timeout:
            errorString = NSLocalizedString(@"The request timed out on the server. Typically this indicates the request is too expensive.", @"");
            break;
        case TBParseError_UnsavedFile:
            errorString = NSLocalizedString(@"Unsaved file.", @"");
            break;
        case TBParseError_UserCannotBeAlteredWithoutSession:
            errorString = NSLocalizedString(@"The user cannot be altered by a client without the session.", @"");
            break;
        case TBParseError_UserCanOnlyBeCreatedThroughSignUp:
            errorString = NSLocalizedString(@"Users can only be created through sign up.", @"");
            break;
        case TBParseError_UserEmailMissing:
            errorString = NSLocalizedString(@"The email is missing, and must be specified", @"");
            break;
        case TBParseError_UserEmailTaken:
            errorString = NSLocalizedString(@"Email has already been taken.", @"");
            break;
        case TBParseError_UserIdMismatch:
            errorString = NSLocalizedString(@"User ID mismatch.", @"");
            break;
        case TBParseError_UsernameMissing:
            errorString = NSLocalizedString(@"Product purchase receipt is missing.", @"");
            break;
        case TBParseError_UsernameTaken:
            errorString = NSLocalizedString(@"Username has already been taken.", @"");
            break;
        case TBParseError_UserPasswordMissing:
            errorString = NSLocalizedString(@"Password is missing or empty.", @"");
            break;
        case TBParseError_UserWithEmailNotFound:
            errorString = NSLocalizedString(@"A user with the specified email was not found.", @"");
            break;
        case TBParseError_ScriptError:
            errorString = NSLocalizedString(@"Cloud Code script had an error.", @"");
            break;
        case TBParseError_ValidationError:
            errorString = NSLocalizedString(@"Cloud Code validation failed.", @"");
            break;
        default:
            errorString = NSLocalizedString(@"Unknown Error", @"");
            break;
    }
    return errorString;
}

@end