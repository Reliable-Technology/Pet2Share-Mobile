//
//  Pet2ShareService.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Pet2ShareService.h"
#import "HttpClient.h"
#import "UrlManager.h"
#import "Utils.h"

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}

@implementation Pet2ShareService

#pragma mark - Private Instance Methods

- (void)parseResponse:(HttpResponse *)response
             callback:(NSObject<Pet2ShareServiceCallback> *)callback
{
    NSError *error;
    ErrorMessage *errorMessage = nil;
    NSMutableArray *objects = [NSMutableArray array];
    
    @try
    {
        if (!response.hasError && [self.jsonModel isSubclassOfClass:[RepositoryObject class]])
        {
            ResponseObject *responseObj = [[ResponseObject alloc] initWithDictionary:response.json error:&error];
            errorMessage = responseObj.errorMessage;
            
            if (!responseObj)
            {
                NSLog(@"%s: Can't parse the ResponseObject: %@", __func__, error);
            }
            else
            {
                for (NSInteger i = 0; i < responseObj.results.count; i++)
                {
                    id object = [[[self.jsonModel class] alloc] initWithDictionary:responseObj.results[i]
                                                                             error:&error];
                    if (object && [(RepositoryObject *)object isValidate]) [objects addObject:object];
                    else NSLog(@"%s: Can't parse the Object: %@", __func__, error);
                }
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: exception occurred: %@", __func__, exception);
        errorMessage = [ErrorMessage new];
        errorMessage.message = exception.description;
    }
    @finally
    {
        @try
        {
            if (!errorMessage) [callback onReceiveSuccess:objects];
            else [callback onReceiveError:errorMessage];
        }
        @catch (NSException *exception)
        {
             NSLog(@"%s: exception on finally: %@", __func__, exception);
        }
    }
}

#pragma mark - Public Instance Methods

- (void)loginUser:(NSObject<Pet2ShareServiceCallback> *)callback
         username:(NSString *)username
         password:(NSString *)password
{
    fTRACE("Username: %@ - Password: %@", username, password);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:ObjectOrNull(username) forKey:@"UserName"];
    [postData setObject:ObjectOrNull(password) forKey:@"Password"];
    
    HttpClient *client = [HttpClient baseUrl:[[UrlManager sharedInstance] webServiceUrl]];
    self.jsonModel = [User class];
    
    [client post:LOGIN_ENDPOINT
            data:postData
        callback:[HttpCallback callbackWithResult:^(HttpResponse *response) {
        [self parseResponse:response callback:callback];
    }]];
}

- (void)registerUser:(NSObject<Pet2ShareServiceCallback> *)callback
           firstname:(NSString *)firstname
            lastname:(NSString *)lastname
            username:(NSString *)username
            password:(NSString *)password
               phone:(NSString *)phone
{
    fTRACE("Firstname: %@ - Lastname: %@ - Username: %@ - Password: %@ - Phone: %@", firstname, lastname, username, password, phone);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:ObjectOrNull(firstname) forKey:@"FirstName"];
    [postData setObject:ObjectOrNull(lastname) forKey:@"LastName"];
    [postData setObject:ObjectOrNull(username) forKey:@"UserName"];
    [postData setObject:ObjectOrNull(password) forKey:@"Password"];
    [postData setObject:ObjectOrNull(phone) forKey:@"Phone"];
    
    HttpClient *client = [HttpClient baseUrl:[[UrlManager sharedInstance] webServiceUrl]];
    self.jsonModel = [User class];
    
    [client post:REGISTER_ENDPOINT
            data:postData
        callback:[HttpCallback callbackWithResult:^(HttpResponse *response) {
        [self parseResponse:response callback:callback];
    }]];
}

@end
