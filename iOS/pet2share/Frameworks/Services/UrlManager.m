//
//  UrlManager.m
//  pet2share
//
//  Created by Tony Kieu on 8/2/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "UrlManager.h"

///------------------------------------------------------------------------------
/// Url
///------------------------------------------------------------------------------
#pragma mark - Url

@interface Url : NSObject

@property (nonatomic, strong) NSString *base;
@property (nonatomic, strong) NSString *webServicePath;

- (id)initWithBase:(NSString *)base servicePath:(NSString *)servicePath;
- (NSString *)toWebServiceUrl;

@end

@implementation Url

- (id)initWithBase:(NSString *)base servicePath:(NSString *)servicePath
{
    if ((self = [super init]))
    {
        self.base = base;
        self.webServicePath = servicePath;
    }
    return self;
}

- (NSString *)toWebServiceUrl
{
    NSString *webservicePath = self.webServicePath != nil ? self.webServicePath : PET2SHARE_PROD_WEBSERVICE_PATH;
    return [NSString stringWithFormat:@"%@%@", self.base, webservicePath];
}

@end

///------------------------------------------------------------------------------
/// UrlManager
///------------------------------------------------------------------------------
#pragma mark - UrlManager

static UrlManager *_sharedInstance = nil;

@interface UrlManager ()

@property (nonatomic, strong) NSDictionary *urlDict;

@end

@implementation UrlManager

#pragma mark - Life Cycle

+ (UrlManager *)sharedInstance
{
    @synchronized (self)
    {
        if (!_sharedInstance)
        {
            _sharedInstance = [UrlManager new];
        }
    }
    return _sharedInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
        _urlDict = [[NSDictionary alloc] initWithObjectsAndKeys:
#ifdef LOCALWEBSERVICE_TEST
                    [[Url alloc] initWithBase:PET2SHARE_DEV_LOCAL_URL servicePath:PET2SHARE_DEV_LOCAL_WEBSERVICE_PATH], PET2SHARE_DEV_KEY,
#else
                    [[Url alloc] initWithBase:PET2SHARE_DEV_URL servicePath:PET2SHARE_DEV_WEBSERVICE_PATH], PET2SHARE_DEV_KEY,
#endif
                    [[Url alloc] initWithBase:PET2SHARE_QA_URL servicePath:PET2SHARE_QA_WEBSERVICE_PATH], PET2SHARE_QA_KEY,
                    [[Url alloc] initWithBase:PET2SHARE_STAGING_URL servicePath:PET2SHARE_STAGING_WEBSERVICE_PATH], PET2SHARE_STAGING_KEY,
                    [[Url alloc] initWithBase:PET2SHARE_PROD_URL servicePath:PET2SHARE_PROD_WEBSERVICE_PATH], PET2SHARE_PROD_KEY, nil];
    }
    return self;
}

#pragma mark - Private Instance Methods

- (Url *)getUrl
{
    // TODO: Refactor this environment later
    NSString *currEnv = PET2SHARE_DEV_KEY;
    if (!currEnv) currEnv = PET2SHARE_PROD_KEY;
    
    Url *url = [self.urlDict objectForKey:currEnv];
    if (!url) [self.urlDict objectForKey:PET2SHARE_PROD_KEY];
    
    return url;
}

#pragma mark - Public Instance Methods

- (NSString *)webServiceUrl
{
    NSString *url = [[self getUrl] toWebServiceUrl];
    if (self.redirectionUrl)
    {
        NSLog(@"%s: applying redirection url: %@", __func__, self.redirectionUrl);
        url = self.redirectionUrl;
    }
        
    return url;
}

- (NSString *)webServiceUrl:(NSString*)endpoint
{
    NSString *webserviceUrl = [self webServiceUrl];
    NSString *newURL = kEmptyString;
    
    // Add trailing slash to the end of web service
    if (![webserviceUrl hasSuffix:@"/"])
    {
        newURL = [NSString stringWithFormat:@"%@/%@", webserviceUrl, endpoint];
    }
    else
    {
        newURL = [NSString stringWithFormat:@"%@%@", webserviceUrl, endpoint];
    }
    
    fTRACE("result url=%@", newURL);
    
    return newURL;
}

@end
