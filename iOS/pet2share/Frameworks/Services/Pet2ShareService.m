//
//  Pet2ShareService.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Pet2ShareService.h"
#import "HttpClient.h"
#import "User.h"
#import "UrlManager.h"

@implementation Pet2ShareService

#pragma mark - Private Instance Methods

- (void)parseResponse:(HttpResponse *)response
             callback:(NSObject<Pet2ShareServiceCallback> *)callback
{
    NSError *error = nil;
    id object = nil;
    
    @try
    {
        if (!response.hasError)
        {
            NSString *status = response.json[@"status"];
            NSDictionary *data = response.json[@"data"];
            
            if ([status isEqualToString:@"success"])
            {
                object = [[[self.jsonModel class] alloc] initWithDictionary:data error:&error];
                if (object == nil) NSLog(@"%s: fail to parse reponse object: %@", __func__, error);
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s: exception occurred: %@", __func__, exception);
        object = exception.reason;
    }
    @finally
    {
        @try
        {
            if (!response.hasError && object) [callback onReceiveSuccess:object];
            else [callback onReceiveError:object];
        }
        @catch(NSException *exception)
        {
            NSLog(@"%s: exception on finally: %@", __func__, exception);
        }
    }
}

#pragma mark - Public Instance Methods

- (void)login:(NSObject<Pet2ShareServiceCallback> *)callback
     username:(NSString *)username
     password:(NSString *)password
{
    fTRACE("Username: %@ - Password: %@", username, password);
    
    HttpClient *client = [HttpClient baseUrl:[[UrlManager sharedInstance] webServiceUrl]];
    self.jsonModel = [User class];
    [client get:[NSString stringWithFormat:AUTHENTICATE_ENDPOINT, username, password]
       callback:[HttpCallback callbackWithResult:^(HttpResponse *response) {
        [self parseResponse:response callback:callback];
    }]];
}

@end
