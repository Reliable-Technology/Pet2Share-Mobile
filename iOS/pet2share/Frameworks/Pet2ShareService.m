//
//  Pet2ShareService.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Pet2ShareService.h"
#import "HttpClient.h"

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
            object = [[[self.jsonModel class] alloc] initWithDictionary:response.json];
            if (object == nil) NSLog(@"%s: fail to parse reponse object: %@", __func__, error);
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
            if (!response.hasError) [callback onReceiveSuccess:object];
            else[callback onReceiveError:object];
        }
        @catch(NSException *exception)
        {
            NSLog(@"%s: exception on finally: %@", __func__, exception);
        }
    }
}

- (void)login:(NSObject<Pet2ShareServiceCallback> *)callback
     username:(NSString *)username
     password:(NSString *)password
{
    fTRACE("Username: %@ - Password: %@", username, password);
    
    HttpClient *client = [HttpClient baseUrl:@"http://45.27.154.30"];
    [client get:[NSString stringWithFormat:@"authenticate/@%@/%@", username, password]
       callback:[HttpCallback callbackWithResult:^(HttpResponse *response) {
        [self parseResponse:response callback:callback];
    }]];
}

@end
