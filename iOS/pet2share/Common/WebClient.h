//
//  WebClient.h
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_STATUS_OK                  200
#define HTTP_STATUS_CREATED             201
#define HTTP_STATUS_ACCEPTED            202
#define HTTP_STATUS_NOCONTENT           204
#define HTTP_STATUS_FORBIDDEN           403
#define HTTP_STATUS_NOTFOUND            404
#define HTTP_STATUS_METHODNOTALLOWED    405
#define HTTP_STATUS_NOT_ACCEPTABLE      406
#define HTTP_STATUS_CONFLICT            409
#define CONTENT_TYPE_HEADER             @"Content-Type"
#define CONTENT_TYPE_JSON               @"application/json"
#define CONTENT_TYPE_XML                @"application/xml"
#define CONTENT_TYPE_OCTET_STREAM       @"binary/octet-stream"

#define WEBCLIENT_DEFAULT_TIMEOUT       90

@class WebClient;

@protocol WebClientDelegate <NSObject>

@optional
- (void)didFinishDownload:(NSData *)data;
- (void)didFinishDownload:(NSError *)error webClient:(WebClient *)webClient;
- (void)didFailDownload:(NSError *)error;
- (void)didFailDownload:(NSError *)error webClient:(WebClient *)webClient;

@end

@interface WebClient : NSObject

@property (nonatomic, strong) NSString *lastUrl;
@property (nonatomic, strong) NSData *lastData;
@property (nonatomic, strong) NSString *lastMethod;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestToken;
@property (nonatomic, strong) NSString *acceptType;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, assign) NSInteger timeOut;
@property (nonatomic, strong) id<WebClientDelegate> delegate;
@property (nonatomic, assign) NSDictionary *customHeaders;
@property (nonatomic, assign) BOOL isRest;
@property (nonatomic, assign) BOOL didReLogin;
@property (nonatomic, assign) NSString *requestTag;
@property (nonatomic, assign) BOOL ignoreResponses;
@property (nonatomic, assign) BOOL forceResponsesProcessing;
@property (nonatomic, assign) BOOL contentTypeJSON;
@property (nonatomic, assign) BOOL allowSelfSignedCerts;
@property (nonatomic, strong) NSURLResponse *httpResponse;
@property (nonatomic, strong) NSURLConnection *httpConnection;
@property (nonatomic, assign) BOOL ignoreWifiRestrictionSetting;

@property (nonatomic, strong) void (^successHandler)(NSInteger successCode, NSData* webClient);
@property (nonatomic, strong) void (^failureHandler)(NSInteger failureCode, NSData* webClient);

- (void)get:(NSString *)urlString;
- (void)get:(NSString *)urlString queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
- (void)post:(NSString*)urlString postData: (NSData*) data queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
- (void)post:(NSString *)urlString postData:(NSString *)postData;
- (void)post:(NSString *)urlString binaryData:(NSData *)data;
- (void)put:(NSString *)urlString putData:(NSString *)putData;
- (void)del:(NSString *)urlString;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)notifyDelegateOnFailure:(NSError *)error;
- (void)notifyDelegateOnSuccess;
- (void)cancelConnection;
- (NSString *)getResponseContentType;

@end