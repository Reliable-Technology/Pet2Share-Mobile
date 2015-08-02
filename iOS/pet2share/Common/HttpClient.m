//
//  HttpClient.m
//  Pet2Share
//
//  Created by Tony Kieu on 7/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "AFNetworking.h"
#import "HttpClient.h"

///------------------------------------------------
/// HttpError
///------------------------------------------------
#pragma mark - HttpError

@implementation HttpError

@synthesize code = _code;
@synthesize message = _message;

+ (instancetype)errorWithCode:(NSString *)code message:(NSString *)message
{
    return [[self alloc] initWithCode:code message:message];
}

- (HttpError *)initWithCode:(NSString *)code message:(NSString *)message
{
    if ((self = [super init]))
    {
        _code = code;
        _message = message;
    }
    return self;
}

@end

///------------------------------------------------
/// HttpResponse
///------------------------------------------------
#pragma mark - HttpResponse

@implementation HttpResponse

@synthesize statusCode = _statusCode;
@synthesize headers = _headers;
@synthesize error = _error;
@synthesize hasError = _hasError;
@synthesize json = _json;

@end

///------------------------------------------------
/// HttpCallback
///------------------------------------------------
#pragma mark - HttpCallback

@implementation HttpCallback

@synthesize result = _result;

+ (instancetype)callbackWithResult:(ResponseBlock)result
{
    return [[self alloc] initWithResult:result];
}

- (id)initWithResult:(ResponseBlock)result
{
    if ((self = [super init]))
    {
        _result = result;
    }
    return self;
}

@end

///------------------------------------------------
/// HttpClient
///------------------------------------------------
#pragma mark - HttpClient

@interface HttpClient ()

@property (nonatomic, readonly) NSMutableDictionary *customHeaders;
@property (nonatomic, readonly) NSURL *baseUrl;

@end

@implementation HttpClient

#pragma mark - Life Cycle

+ (instancetype)baseUrl:(NSString *)baseUrl
{
    return [[self alloc] initRequestWithBaseUrl:baseUrl];
}

- (id)initRequestWithBaseUrl:(NSString *)baseUrl
{
    if ((self = [super init]))
    {
        _requestSerializer = [AFJSONRequestSerializer new];
        _responseSerializer = [AFJSONResponseSerializer new];
        _allowInvalidCertificates = NO;
        
        if (baseUrl)
        {
            NSURL *url = [NSURL URLWithString:baseUrl];
            if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"])
            {
                url = [url URLByAppendingPathComponent:@""];
            }
            _baseUrl = url;
        }
        else
        {
            _baseUrl = [NSURL URLWithString:@""];
        }
    }
    return self;
}

#pragma mark - Private Instance Methods

- (NSMutableURLRequest *)buildRequest:(NSString *)method path:(NSString *)path data:(NSDictionary *)data
{
    NSString *urlString = [[NSURL URLWithString:path relativeToURL:self.baseUrl] absoluteString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:urlString parameters:data error:nil];
    
    for (NSString *key in [self.customHeaders allKeys])
    {
        [request setValue:[self.customHeaders objectForKey:key] forHTTPHeaderField:key];
    }
    
    return request;
}

- (void)performRequest:(NSURLRequest *)request callback:(HttpCallback *)callback
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id json) {
        HttpResponse *response = [self parseJsonResponse:operation.response request:operation.request data:json];
        callback.result(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HttpResponse *response = [self parseJsonResponse:operation.response request:operation.request data:nil];
        callback.result(response);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (HttpResponse *)parseJsonResponse:(NSHTTPURLResponse *)urlResponse request:(NSURLRequest *)urlRequest data:(id)data
{
    HttpResponse *response = [HttpResponse new];
    response.statusCode = [NSNumber numberWithInteger:urlResponse.statusCode];
    response.headers = urlResponse.allHeaderFields;
    response.json = data;
    
    if (response.json == nil)
    {
        response.error = [HttpError errorWithCode:[NSString stringWithFormat:@"%d", HTTP_STATUS_NOCONTENT]
                                          message:NSLocalizedString(@"The content is empty", @"")];
    }
    
    if (!(urlResponse.statusCode >= HTTP_STATUS_OK && urlResponse.statusCode < HTTP_STATUS_MULTIPLECHOICES))
    {
        response.error = [HttpError errorWithCode:[response.statusCode stringValue]
                                          message:[NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]];
    }
    response.hasError = response.error != nil;
    
    return response;
}

- (HttpResponse *)parseXmlResponse:(NSHTTPURLResponse *)reseponse request:(NSURLRequest *)request data:(id)data
{
    // TODO: Implement later
    return nil;
}

#pragma mark - Public Instance Methods

- (void)addCustomHeaders:(id)key value:(id)value
{
    if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]])
    {
        [self.customHeaders setObject:value forKey:key];
    }
}

- (void)get:(NSString*)path callback:(HttpCallback *)callback
{
    NSMutableURLRequest *request = [self buildRequest:@"GET" path:path data:nil];
    [self performRequest:request callback:callback];
}

- (void)post:(NSString *)path data:(NSDictionary *)data callback:(HttpCallback *)callback
{
    NSMutableURLRequest *request = [self buildRequest:@"POST" path:path data:data];
    [self performRequest:request callback:callback];
}

- (void)put:(NSString *)path data:(NSDictionary *)data callback:(HttpCallback *)callback
{
    NSMutableURLRequest *request = [self buildRequest:@"PUT" path:path data:data];
    [self performRequest:request callback:callback];
}

- (void)del:(NSString *)path callback:(HttpCallback *)callback
{
    NSMutableURLRequest *request = [self buildRequest:@"DELETE" path:path data:nil];
    [self performRequest:request callback:callback];
}

@end