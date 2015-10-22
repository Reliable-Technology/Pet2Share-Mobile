//
//  WebClient.m
//  pet2share
//
//  Created by Tony Kieu on 10/13/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "WebClient.h"
#import "Reachability.h"

#define JSON_RESPONSE                   @"json"
#define HTTP_HEADER_CONTENTLENGTH       @"Content-Length"
#define HTTP_HEADER_ACCEPT              @"Accept"
#define HTTP_HEADER_ACCEPTENCODING      @"Accept-Encoding"
#define HTTP_GET_METHOD                 @"GET"
#define HTTP_POST_METHOD                @"POST"
#define HTTP_PUT_METHOD                 @"PUT"
#define HTTP_DELETE_METHOD              @"DELETE"

@implementation WebClient
{
    void (^ completionHander) (NSURLResponse*, NSData*, NSError*);
    NSOperationQueue *operationQueue;
}

#define WEB_EXCEPTION_TITLE @"WebClient Error"

@synthesize receivedData, lastUrl, lastData, lastMethod, timeOut, ignoreResponses;
@synthesize statusCode, delegate, didReLogin, customHeaders;
@synthesize requestToken, acceptType, contentType, isRest, requestTag, ignoreWifiRestrictionSetting;
@synthesize contentTypeJSON, allowSelfSignedCerts;

- (id)init
{
    if ((self = [super init]))
    {
        self.receivedData = [NSMutableData new];
        self.isRest = NO;
        self.contentTypeJSON = NO;
        self.didReLogin = NO;
        self.allowSelfSignedCerts = NO;
        self.timeOut = WEBCLIENT_DEFAULT_TIMEOUT;
        self.ignoreResponses = NO;
    }
    
    return self;
}

#pragma mark -
#pragma mark Setter

- (void)setIsRest:(BOOL)value
{
    isRest = value;
    
    if (isRest == YES && contentTypeJSON == NO)
        self.contentType = CONTENT_TYPE_XML;
}

- (void)setContentTypeJSON:(BOOL)value
{
    contentTypeJSON = value;
    if (contentTypeJSON == YES)
        self.contentType = CONTENT_TYPE_JSON;
}

#pragma mark -
#pragma mark Private Instance Methods

- (NSMutableURLRequest *)createUrlRequest:(NSString *)urlString data:(NSData *)data byMethod:(NSString *)method
{
    [receivedData setLength:0];
    
    self.lastUrl = urlString;
    self.lastData = data;
    self.lastMethod = method;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL: [NSURL URLWithString:urlString]
                                    cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                    timeoutInterval: timeOut
                                    ];
    // Add custom headers (if any)
    if (self.customHeaders)
    {
        [customHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             if([key isKindOfClass: [NSString class]] && [obj isKindOfClass: [NSString class]])
             {
                 [request addValue: obj forHTTPHeaderField: key];
             }
         }];
    }
    
    [request addValue:@"deflate,gzip" forHTTPHeaderField:HTTP_HEADER_ACCEPTENCODING];
    
    if (self.contentType.length > 0)
    {
        [request setValue:self.contentType forHTTPHeaderField:CONTENT_TYPE_HEADER];
        [request setValue:[NSString stringWithFormat:@"%lu",
                           (unsigned long)data.length] forHTTPHeaderField:HTTP_HEADER_CONTENTLENGTH];
    }
    
    if (self.acceptType.length > 0)
    {
        [request setValue:self.acceptType forHTTPHeaderField:HTTP_HEADER_ACCEPT];
    }
    [request setHTTPMethod:method];
    
    if ([method isEqualToString:HTTP_POST_METHOD] || [method isEqualToString:HTTP_PUT_METHOD])
    {
        [request setHTTPBody:data];
    }
    
    return request;
}

- (void)performRequest:(NSString *)urlString data:(NSData *)data byMethod:(NSString *)method
{
    NSURLRequest *request = [self createUrlRequest:urlString data:data byMethod:method];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:YES];
    if(!connection)
    {
        fTRACE("%@", @"WebClient connect FAILED");
    }
}

- (void)performRequest:(NSString *) urlString
                  data:(NSData *) data
              byMethod:(NSString *) method
                 queue:(NSOperationQueue *) queue
     completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    operationQueue = queue;
    completionHander = handler;
    
    [self performRequest: urlString data: data byMethod: method];
}

- (void)cancelConnection
{
    [self.httpConnection cancel];
}

- (BOOL)isSuccessCode:(NSInteger)code
{
    return HTTP_STATUS_OK == code
    || HTTP_STATUS_CREATED == code
    || HTTP_STATUS_NOCONTENT == code;
}

- (void)notifyDelegateOnFailure:(NSError *)error
{
    if(operationQueue && completionHander)
        [operationQueue addOperationWithBlock: ^{ completionHander(nil, nil, error); }];
    
    if ([delegate respondsToSelector:@selector(didFailDownload:)])
        [delegate performSelector:@selector(didFailDownload:) withObject:error];
    else if([delegate respondsToSelector:@selector(didFailDownload:webClient:)])
        [delegate performSelector:@selector(didFailDownload:webClient:) withObject:error withObject:self];
    else if (self.failureHandler != nil)
        self.failureHandler(self.statusCode, self.receivedData);
}

- (void)notifyDelegateOnSuccess
{
    if(operationQueue && completionHander)
        [operationQueue addOperationWithBlock: ^{ completionHander(nil, receivedData, nil); }];
    
    if ([delegate respondsToSelector:@selector(didFinishDownload:)])
        [delegate performSelector:@selector(didFinishDownload:) withObject:receivedData];
    else if ([delegate respondsToSelector:@selector(didFinishDownload:webClient:)])
        [delegate performSelector:@selector(didFinishDownload:webClient:) withObject:receivedData withObject:self];
    else if (self.successHandler != nil)
        self.successHandler(self.statusCode, self.receivedData);
}

#pragma mark - 
#pragma mark Public Instance Methods

- (void)get:(NSString *)urlString
{
    [self performRequest:urlString data:nil byMethod:HTTP_GET_METHOD];
}

- (void)get:(NSString *)urlString queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    [self performRequest:urlString data:nil byMethod:HTTP_GET_METHOD queue:queue completionHandler:handler];
}

- (void)post:(NSString*)urlString postData: (NSData*) data queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    [self performRequest:urlString data:data byMethod:HTTP_POST_METHOD queue:queue completionHandler:handler];
}

- (void)post:(NSString *)urlString binaryData:(NSData *)data
{
    [self performRequest:urlString data:data byMethod:HTTP_POST_METHOD];
}

- (void)post:(NSString *)urlString postData:(NSString *)postData
{
    [self performRequest:urlString data:[postData dataUsingEncoding:NSUTF8StringEncoding] byMethod:HTTP_POST_METHOD];
}

- (void)del:(NSString *)urlString
{
    [self performRequest:urlString data:nil byMethod:HTTP_DELETE_METHOD];
}

- (void)put:(NSString *)urlString putData:(NSString *)putData
{
    [self performRequest:urlString data:[putData dataUsingEncoding:NSUTF8StringEncoding] byMethod:HTTP_PUT_METHOD];
}

- (NSString *)getResponseContentType
{
    NSDictionary *headers = [(NSHTTPURLResponse*)self.httpResponse allHeaderFields];
    NSString *content_type = [headers objectForKey:CONTENT_TYPE_HEADER];
    return content_type;
}

#pragma mark -
#pragma mark <NSURLConnectionDelegate>

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    return request;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    fTRACE("Total bytes written: %ld, Total expected bytes: %ld", (long)totalBytesWritten, (long)totalBytesExpectedToWrite);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
    self.httpResponse = response;
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
    self.statusCode = [urlResponse statusCode];
    
    fTRACE("Received response: %li\nfrom %@", (long)self.statusCode, self.lastUrl);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    fTRACE("Received %lu bytes of data", (unsigned long)[data length]);
    [receivedData appendData:data];
    fTRACE("Received data is now %lu bytes", (unsigned long)[receivedData length]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    TRACE_HERE;
    return (allowSelfSignedCerts) ? [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] : NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    TRACE_HERE;
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
         forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    fTRACE("Error receiving response: %@", error);
    [self notifyDelegateOnFailure: error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.ignoreResponses && !self.forceResponsesProcessing) return;
    
    if ([receivedData length] == 1 || self.statusCode == HTTP_STATUS_FORBIDDEN)
    {
        if (self.didReLogin) self.statusCode = HTTP_STATUS_FORBIDDEN;
    }
    
    // Once this method is invoked, "responseData" contains the complete result
    if (![self isSuccessCode: self.statusCode])
    {
        fTRACE("Error receiving response with status code: %ld and data:\r %@",
               (long)self.statusCode,
               [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding]);
        
        [self notifyDelegateOnFailure:nil];
    }
    else
    {
        [self notifyDelegateOnSuccess];
    }
}

@end