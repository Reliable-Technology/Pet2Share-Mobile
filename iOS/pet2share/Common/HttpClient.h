//
//  HttpClient.h
//  Pet2Share
//
//  Created by Tony Kieu on 7/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - HTTP Status Code

#define HTTP_STATUS_OK                  200
#define HTTP_STATUS_CREATED             201
#define HTTP_STATUS_ACCEPTED            202
#define HTTP_STATUS_NOCONTENT           204
#define HTTP_STATUS_MULTIPLECHOICES     300
#define HTTP_STATUS_FORBIDDEN           403
#define HTTP_STATUS_NOTFOUND            404
#define HTTP_STATUS_METHODNOTALLOWED    405
#define HTTP_STATUS_CONFLICT            409

#pragma mark - HttpError

@interface HttpError : NSObject
{
    NSString *_code;
    NSString *_message;
}

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;

+ (instancetype)errorWithCode:(NSString *)code message:(NSString *)message;
- (HttpError *)initWithCode:(NSString *)code message:(NSString *)message;

@end

#pragma mark - HttpResponse

@interface HttpResponse : NSObject

@property (nonatomic, strong) NSNumber *statusCode;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, strong) HttpError *error;
@property (nonatomic, strong) id json;

@end

#pragma mark - HttpCallback

typedef void (^ResponseBlock)(HttpResponse *);

@interface HttpCallback : NSObject
{
    ResponseBlock _result;
}

@property (nonatomic, readonly) ResponseBlock result;

+ (instancetype)callbackWithResult:(ResponseBlock)result;

- (id)initWithResult:(ResponseBlock)result;

@end

#pragma mark - HttpClient

@class AFHTTPRequestSerializer;
@class AFHTTPResponseSerializer;

@interface HttpClient : NSObject

@property (nonatomic, assign) BOOL allowInvalidCertificates;
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;

+ (instancetype)baseUrl:(NSString *)baseUrl;

- (void)addCustomHeaders:(id)key value:(id)value;
- (void)get:(NSString*)path callback:(HttpCallback *)callback;
- (void)post:(NSString *)path data:(NSDictionary *)data callback:(HttpCallback *)callback;
- (void)put:(NSString *)path data:(NSDictionary *)data callback:(HttpCallback *)callback;
- (void)del:(NSString *)path callback:(HttpCallback *)callback;

@end