//
//  Pet2ShareService.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <EGOCache/EGOCache.h>
#import "Pet2ShareService.h"
#import "UrlManager.h"
#import "Utils.h"
#import "WebClient.h"
#import "CacheKey.h"

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}


@interface Pet2ShareService () <WebClientDelegate>
{
    BOOL _didReceivedData;
}

@property (nonatomic, weak) id<Pet2ShareServiceCallback> callback;
@property (nonatomic, strong) Class jsonModel;
@property (nonatomic, assign) CachePolicy cachePolicy;
@property (nonatomic, strong) CacheKey *cacheKey;

@end

@implementation Pet2ShareService

+ (Pet2ShareService *)sharedService
{
    static Pet2ShareService *_sharedService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [Pet2ShareService new];
    });
    return _sharedService;
}

- (id)init
{
    if ((self = [super init]))
    {
        _cachePolicy = -1;
        _didReceivedData = NO;
    }
    return self;
}

#pragma mark - Private Instance Methods

- (void)postJsonRequest:(NSObject<Pet2ShareServiceCallback> *)callback
               endPoint:(NSString *)endPoint
              jsonModel:(Class)model
           postData:(NSDictionary *)postData
{
    NSString *data = [Utils jsonRepresentation:postData];
    NSString *url = [[UrlManager sharedInstance] webServiceUrl:endPoint];
    
    WebClient *webClient = [WebClient new];
    webClient.delegate = self;
    webClient.contentTypeJSON = YES;
    self.jsonModel = model;
    self.callback = callback;
    
    fTRACE(@"Post Request: %@", url);

    [webClient post:url postData:data];
}

- (void)postJsonRequest:(NSObject<Pet2ShareServiceCallback> *)callback
               endPoint:(NSString *)endPoint
              jsonModel:(Class)model
               postData:(NSDictionary *)postData
            cachePolicy:(CachePolicy)cachePolicy
               cacheKey:(CacheKey *)cacheKey
{
    NSString *data = [Utils jsonRepresentation:postData];
    NSString *url = [[UrlManager sharedInstance] webServiceUrl:endPoint];
    _didReceivedData = NO;
    
    WebClient *webClient = [WebClient new];
    webClient.delegate = self;
    webClient.contentTypeJSON = YES;
    self.jsonModel = model;
    self.callback = callback;
    self.cachePolicy = cachePolicy;
    self.cacheKey = cacheKey;
    
    switch (self.cachePolicy)
    {
        case CacheDefault:
        {
            if ([[EGOCache globalCache] hasCacheForKey:self.cacheKey.getKey])
            {
                webClient.statusCode = HTTP_STATUS_OK;
                NSData *data = [[EGOCache globalCache] dataForKey:self.cacheKey.getKey];
                [self didFinishDownload:data];
            }
            [webClient post:url postData:data];
            break;
        }
            
        case NotExpired:
        {
            if ([[EGOCache globalCache] hasCacheForKey:self.cacheKey.getKey])
            {
                webClient.statusCode = HTTP_STATUS_OK;
                NSData *data = [[EGOCache globalCache] dataForKey:self.cacheKey.getKey];
                [self didFinishDownload:data];
            }
            else
            {
                [webClient post:url postData:data];
            }
            break;
        }
            
        case NoCache:
        case ForceRefresh:
        {
            [[EGOCache globalCache] removeCacheForKey:self.cacheKey.getKey];
            [webClient post:url postData:data];
            break;
        }
            
        default:
            break;
    }
}

- (void)processResponseData:(NSData *)data
{
    ErrorMessage *errorMessage = nil;
    NSMutableArray *objects = [NSMutableArray array];

    @try
    {
        if ([self.jsonModel isSubclassOfClass:[RepositoryObject class]])
        {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            fTRACE("Response JSON: %@", json);
            
            if (json)
            {
                ResponseObject *responseObj = [[ResponseObject alloc] initWithDictionary:json error:&error];
                errorMessage = responseObj.errorMessage;
                
                if (!responseObj)
                {
                    fTRACE("%s: Can't parse the ResponseObject: %@", __func__, error);
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
            if (!errorMessage)
            {
                if ([self.callback respondsToSelector:@selector(onReceiveSuccess:service:)])
                    [self.callback onReceiveSuccess:objects service:self];
                else if ([self.callback respondsToSelector:@selector(onReceiveSuccess:)])
                    [self.callback onReceiveSuccess:objects];
            }
            else
            {
                if ([self.callback respondsToSelector:@selector(onReceiveError:service:)])
                    [self.callback onReceiveError:errorMessage service:self];
                else if ([self.callback respondsToSelector:@selector(onReceiveError:)])
                    [self.callback onReceiveError:errorMessage];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"%s: exception on finally: %@", __func__, exception);
        }
    }
}

#pragma mark - <WebClientDelegate>

- (void)didFinishDownload:(NSData *)data
{
    TRACE_HERE;
    
    if (_didReceivedData) return;
    
    if (self.cachePolicy == CacheDefault)
        [[EGOCache globalCache] setData:data forKey:self.cacheKey.getKey withTimeoutInterval:kCacheTimeOut];
    else if (self.cachePolicy == NotExpired)
        [[EGOCache globalCache] setData:data forKey:self.cacheKey.getKey];
    
    if (self.callback) [self processResponseData:data];
    _didReceivedData = YES;
}

- (void)didFailDownload:(NSError *)error webClient:(WebClient *)webClient
{
    TRACE_HERE;
    
    if (_didReceivedData) return;
    
    ErrorMessage *errorMessage = [ErrorMessage new];
    errorMessage.message = error.description ?: [NSString stringWithFormat:@"Error with status code: %ld", (long)webClient.statusCode];
    errorMessage.reasonCode = webClient.statusCode;
    if (self.callback) [self.callback onReceiveError:errorMessage];
    _didReceivedData = YES;
}

#pragma mark - Public Instance Methods

- (void)loginUser:(NSObject<Pet2ShareServiceCallback> *)callback
         username:(NSString *)username
         password:(NSString *)password
{
    fTRACE("%@ <Username: %@ - Password: %@>", LOGIN_ENDPOINT, username, password);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:ObjectOrNull(username) forKey:@"UserName"];
    [postData setObject:ObjectOrNull(password) forKey:@"Password"];
    
    [self postJsonRequest:callback endPoint:LOGIN_ENDPOINT jsonModel:[User class] postData:postData];
}

- (void)registerUser:(NSObject<Pet2ShareServiceCallback> *)callback
           firstname:(NSString *)firstname
            lastname:(NSString *)lastname
            username:(NSString *)username
            password:(NSString *)password
               phone:(NSString *)phone
{
    fTRACE("%@ <Firstname: %@ - Lastname: %@ - Username: %@ - Password: %@ - Phone: %@>",
           REGISTER_ENDPOINT, firstname, lastname, username, password, phone);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:ObjectOrNull(firstname) forKey:@"FirstName"];
    [postData setObject:ObjectOrNull(lastname) forKey:@"LastName"];
    [postData setObject:ObjectOrNull(username) forKey:@"UserName"];
    [postData setObject:ObjectOrNull(password) forKey:@"Password"];
    [postData setObject:ObjectOrNull(phone) forKey:@"Phone"];
    
    [self postJsonRequest:callback endPoint:REGISTER_ENDPOINT jsonModel:[User class] postData:postData];
}

- (void)getUserProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                userId:(NSInteger)userId
           cachePolicy:(CachePolicy)cachePolicy
{
    CacheKey *cacheKey = [CacheKey new];
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    
    [cacheKey addKey:[[UrlManager sharedInstance] webServiceUrl:GETUSERPROFILE_ENDPOINT]];
    [postData setObject:@(userId) forKey:@"UserId"];
    [cacheKey addKey:[@(userId) stringValue]];
    
    fTRACE("%@ <Identifier: %ld CacheKey: %@>", GETUSERPROFILE_ENDPOINT, (long)userId, cacheKey);
    
    [self postJsonRequest:callback
                 endPoint:GETUSERPROFILE_ENDPOINT
                jsonModel:[User class]
                 postData:postData
              cachePolicy:cachePolicy
                 cacheKey:cacheKey];
}

- (void)updateUserProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                   userId:(NSInteger)userId
                firstName:(NSString *)firstName
                 lastName:(NSString *)lastName
                    email:(NSString *)email
           alternateEmail:(NSString *)alternateEmail
                    phone:(NSString *)phone
           secondaryPhone:(NSString *)secondaryPhone
              dateOfBirth:(NSDate *)dateOfBirth
                  aboutMe:(NSString *)aboutMe
             addressLine1:(NSString *)addressLine1
             addressLine2:(NSString *)addressLine2
                     city:(NSString *)city
                    state:(NSString *)state
                  country:(NSString *)country
                  zipCode:(NSString *)zipCode
{
    fTRACE("%@ <Identifier: %ld>", UPDATEUSERPROFILE_ENDPOINT, (long)userId);
    
    CacheKey *cacheKey = [CacheKey new];
    [cacheKey addKey:[[UrlManager sharedInstance] webServiceUrl:GETUSERPROFILE_ENDPOINT]];
    [cacheKey addKey:[@(userId) stringValue]];

    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(userId) forKey:@"UserId"];
    [postData setObject:ObjectOrNull(firstName) forKey:@"FirstName"];
    [postData setObject:ObjectOrNull(lastName) forKey:@"LastName"];
    [postData setObject:ObjectOrNull(email) forKey:@"Email"];
    [postData setObject:ObjectOrNull(alternateEmail) forKey:@"AlternateEmail"];
    [postData setObject:ObjectOrNull(phone) forKey:@"PhoneNumber"];
    [postData setObject:ObjectOrNull(secondaryPhone) forKey:@"SecondaryPhone"];
    [postData setObject:[Utils formatNSDateToDateTime:dateOfBirth] forKey:@"DateOfBirth"];
    [postData setObject:ObjectOrNull(aboutMe) forKey:@"AboutMe"];
    [postData setObject:ObjectOrNull(addressLine1) forKey:@"AddressLine1"];
    [postData setObject:ObjectOrNull(addressLine2) forKey:@"AddressLine2"];
    [postData setObject:ObjectOrNull(city) forKey:@"City"];
    [postData setObject:ObjectOrNull(state) forKey:@"State"];
    [postData setObject:ObjectOrNull(country) forKey:@"Country"];
    [postData setObject:ObjectOrNull(zipCode) forKey:@"ZipCode"];
    
    [self postJsonRequest:callback endPoint:UPDATEUSERPROFILE_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)insertPetProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                  userId:(NSInteger)userId
                    name:(NSString *)name
              familyName:(NSString *)familyName
                 petType:(PetType *)petType
             dateOfBirth:(NSDate *)dateOfBirth
                   about:(NSString *)about
                 favFood:(NSString *)favFood
{
    fTRACE("%@ <UserId: %ld>", INSERTPETPROFILE_ENDPOINT, (long)userId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(userId) forKey:@"UserId"];
    [postData setObject:ObjectOrNull(name) forKey:@"Name"];
    [postData setObject:ObjectOrNull(familyName) forKey:@"FamilyName"];
    [postData setObject:ObjectOrNull(petType) forKey:@"PetTypeId"];
    [postData setObject:[Utils formatNSDateToDateTime:dateOfBirth] forKey:@"DOB"];
    [postData setObject:ObjectOrNull(about) forKey:@"About"];
    [postData setObject:ObjectOrNull(favFood) forKey:@"FavFood"];
    
    [self postJsonRequest:callback endPoint:INSERTPETPROFILE_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)updatePetProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                   petId:(NSInteger)petId
                  userId:(NSInteger)userId
                    name:(NSString *)name
              familyName:(NSString *)familyName
                 petType:(PetType *)petType
             dateOfBirth:(NSDate *)dateOfBirth
                   about:(NSString *)about
                 favFood:(NSString *)favFood
{
    fTRACE("%@ <UserId: %ld PetId: %ld>", UPDATEPETPROFILE_ENDPOINT, (long)userId, (long)petId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(petId) forKey:@"PetId"];
    [postData setObject:@(userId) forKey:@"UserId"];
    [postData setObject:ObjectOrNull(name) forKey:@"Name"];
    [postData setObject:ObjectOrNull(familyName) forKey:@"FamilyName"];
    [postData setObject:ObjectOrNull(petType) forKey:@"PetTypeId"];
    [postData setObject:[Utils formatNSDateToDateTime:dateOfBirth] forKey:@"DOB"];
    [postData setObject:ObjectOrNull(about) forKey:@"About"];
    [postData setObject:ObjectOrNull(favFood) forKey:@"FavFood"];
    
    [self postJsonRequest:callback endPoint:UPDATEPETPROFILE_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)getPostsByUser:(NSObject<Pet2ShareServiceCallback> *)callback
                userId:(NSInteger)userId
             postCount:(NSInteger)postCount
            pageNumber:(NSInteger)pageNumber
{
    fTRACE("%@ <UserId: %ld>", GETPOSTSBYUSER_ENDPOINT, (long)userId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(userId) forKey:@"ProfileId"];
    [postData setObject:@(postCount) forKey:@"PostCount"];
    [postData setObject:@(pageNumber) forKey:@"PageNumber"];
    
    [self postJsonRequest:callback endPoint:GETPOSTSBYUSER_ENDPOINT jsonModel:[Post class] postData:postData];
}

- (void)getFeedsRequest:(NSObject<Pet2ShareServiceCallback> *)callback
              profileId:(NSInteger)profileId
            isPostByPet:(BOOL)isPostedByPet
              postCount:(NSInteger)postCount
             pageNumber:(NSInteger)pageNumber
{
    fTRACE("%@ <UserId: %ld>", GETFEEDSREQUEST_ENDPOINT, (long)profileId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(profileId) forKey:@"ProfileId"];
    [postData setObject:[Utils getBooleanString:isPostedByPet] forKey:@"IsRequesterPet"];
    [postData setObject:@(postCount) forKey:@"PostCount"];
    [postData setObject:@(pageNumber) forKey:@"PageNumber"];
    
    [self postJsonRequest:callback endPoint:GETFEEDSREQUEST_ENDPOINT jsonModel:[Post class] postData:postData];
}

- (void)getPostsByPet:(NSObject<Pet2ShareServiceCallback> *)callback
                petId:(NSInteger)petId
            postCount:(NSInteger)postCount
           pageNumber:(NSInteger)pageNumber
{
    fTRACE("%@ <PetId: %ld>", GETPOSTSBYPET_ENDPOINT, (long)petId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(petId) forKey:@"ProfileId"];
    [postData setObject:@(postCount) forKey:@"PostCount"];
    [postData setObject:@(pageNumber) forKey:@"PageNumber"];
    
    [self postJsonRequest:callback endPoint:GETPOSTSBYPET_ENDPOINT jsonModel:[Post class] postData:postData];
}

- (void)addPost:(NSObject<Pet2ShareServiceCallback> *)callback
postDescription:(NSString *)postDescription
       postedBy:(NSInteger)profileId
    isPostByPet:(BOOL)isPostedByPet
{
    fTRACE("%@ <ProfileId: %ld", ADDPOST_ENDPOINT, (long)profileId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(PostWithText) forKey:@"PostTypeId"];  // TODO: Refactor later
    [postData setObject:postDescription forKey:@"Description"];
    [postData setObject:@(profileId) forKey:@"PostedBy"];
    [postData setObject:@(isPostedByPet) forKey:@"IsPostByPet"];
    
    [self postJsonRequest:callback endPoint:ADDPOST_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)addPhotoPost:(NSObject<Pet2ShareServiceCallback> *)callback
         description:(NSString *)description
            postedBy:(NSInteger)profileId
         isPostByPet:(BOOL)isPostedByPet
               image:(UIImage *)image
            fileName:(NSString *)fileName
{
    fTRACE("%@ <ProfileId: %ld", ADDPHOTOPOST_ENDPOINT, (long)profileId);
    NSString *endPoint = [NSString stringWithFormat:@"%@?FileName=%@.png&Description=%@&PostedBy=%ld&IsPostByPet=%@&IsPublic=%@",
                          ADDPHOTOPOST_ENDPOINT, fileName, description, (long)profileId, [Utils getBooleanString:isPostedByPet], @"true"];
    NSString *url = [[UrlManager sharedInstance] webServiceUrl:endPoint];
    NSData *data = UIImageJPEGRepresentation(image, kImageCompressionRatio);
    
    WebClient *webClient = [[WebClient alloc] init];
    webClient.delegate = self;
    webClient.contentType = CONTENT_TYPE_OCTET_STREAM;
    self.callback = callback;
    self.jsonModel = [UpdateMessage class];
    [webClient post:url binaryData:data];
}

- (void)updatePost:(NSObject<Pet2ShareServiceCallback> *)callback
            postId:(NSInteger)postId
   postDescription:(NSString *)postDescription
{
    fTRACE("%@ <PostId: %ld>", UPDATEPOST_ENDPOINT, (long)postId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(postId) forKey:@"PostId"];
    [postData setObject:postDescription forKey:@"PostDescription"];
    
    [self postJsonRequest:callback endPoint:UPDATEPOST_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)deletePost:(NSObject<Pet2ShareServiceCallback> *)callback
            postId:(NSInteger)postId
{
    fTRACE("%@ <PostId: %ld>", DELETEPOST_ENDPOINT, (long)postId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(postId) forKey:@"PostId"];
    
    [self postJsonRequest:callback endPoint:DELETEPOST_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)deletePostByPoster:(NSObject<Pet2ShareServiceCallback> *)callback
                    postId:(NSInteger)postId
                postedById:(NSInteger)postedById
             isPostedByPet:(BOOL)isPostedByPet
{
    fTRACE("%@ <PostId: %ld, PostedBy: %ld>", DELETEPOSTBYPOSTER_ENDPOINT, (long)postId, (long)postedById);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(postId) forKey:@"PostId"];
    [postData setObject:@(postedById) forKey:@"PostedById"];
    [postData setObject:[Utils getBooleanString:isPostedByPet] forKey:@"IsPostedByPet"];
    
    [self postJsonRequest:callback endPoint:DELETEPOSTBYPOSTER_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)getComments:(NSObject<Pet2ShareServiceCallback> *)callback
             postId:(NSInteger)postId
{
    fTRACE("%@ <PostId: %ld>", GETCOMMENTS_ENDPOINT, (long)postId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(postId) forKey:@"PostId"];
    
    [self postJsonRequest:callback endPoint:GETCOMMENTS_ENDPOINT jsonModel:[Comment class] postData:postData];
}

- (void)addComment:(NSObject<Pet2ShareServiceCallback> *)callback
            postId:(NSInteger)postId
       commentById:(NSInteger)userId
  isCommentedByPet:(BOOL)isCommentedByPet
commentDescription:(NSString *)commentDescription
{
    fTRACE("%@ <PostId: %ld - UserId: %ld>", ADDCOMMENT_ENDPOINT, (long)postId, (long)userId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(postId) forKey:@"PostId"];
    [postData setObject:@(userId) forKey:@"CommentedById"];
    [postData setObject:@(NO) forKey:@"IsCommentedByPet"];
    [postData setObject:ObjectOrNull(commentDescription) forKey:@"CommentDescription"];
    
    [self postJsonRequest:callback endPoint:ADDCOMMENT_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)updateComment:(NSObject<Pet2ShareServiceCallback> *)callback
            commentId:(NSInteger)commentId
   commentDescription:(NSString *)commentDescription
{
    fTRACE("%@ <CommentId: %ld>", UPDATECOMMENT_ENDPOINT, (long)commentId);
    
    NSMutableDictionary *postdata = [NSMutableDictionary dictionary];
    [postdata setObject:@(commentId) forKey:@"CommentId"];
    [postdata setObject:ObjectOrNull(commentDescription) forKey:@"CommentDescription"];
    
    [self postJsonRequest:callback endPoint:UPDATECOMMENT_ENDPOINT jsonModel:[UpdateMessage class] postData:postdata];
}

- (void)deleteComment:(NSObject<Pet2ShareServiceCallback> *)callback
            commentId:(NSInteger)commentId
{
    fTRACE("%@ <CommentId: %ld>", DELETECOMMENT_ENDPOINT, (long)commentId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(commentId) forKey:@"CommentId"];
    
    [self postJsonRequest:callback endPoint:DELETECOMMENT_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)deleteCommentByUser:(NSObject<Pet2ShareServiceCallback> *)callback
                  commentId:(NSInteger)commentId
                     userId:(NSInteger)userId
{
    fTRACE("%@ <CommentId: %ld, UserId: %ld>", DELETECOMMENTBYUSER_ENDPOINT, (long)commentId, (long)userId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(commentId) forKey:@"CommentId"];
    [postData setObject:@(userId) forKey:@"UserId"];
    
    [self postJsonRequest:callback endPoint:DELETECOMMENTBYUSER_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)loadImage:(NSString *)url
      aspectRatio:(ImageAspectRatio)aspectRatio
       completion:(void (^)(UIImage* image))completion
{
    if ([Utils isNullOrEmpty:url]) return;

    NSString *aspectRatioCode = kEmptyString;
    
    switch (aspectRatio)
    {
        case Default:
            aspectRatioCode = kEmptyString;
            break;
        case Square:
            aspectRatioCode = @"?w=360&h=360&mode=carve&quality=100";
            break;
        case Landscape:
            aspectRatioCode = @"?w=640&h=360&mode=carve&quality=100";
            break;
        case Portrait:
            aspectRatioCode = kEmptyString;
            break;
        default:
            aspectRatioCode = kEmptyString;
            break;;
    }
    
    if ([[EGOCache globalCache] hasCacheForKey:url])
    {
        NSData *data = [[EGOCache globalCache] dataForKey:url];
        UIImage *image = [UIImage imageWithData:data];
        completion(image);
        return;
    }
    
    dispatch_queue_t imageQueue = dispatch_queue_create("imagedownloadqueue", nil);
    dispatch_async(imageQueue, ^{
        @try
        {
            NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            encodedUrl = [encodedUrl stringByAppendingString:aspectRatioCode];
            fTRACE(@"Image Url: %@", encodedUrl);
            NSURL *imageUrl = [NSURL URLWithString:encodedUrl];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *image = [UIImage imageWithData:data];
            
            if (![[EGOCache globalCache] hasCacheForKey:url])
                [[EGOCache globalCache] setData:data forKey:url withTimeoutInterval:kImageCacheTimeOut];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image);
            });
        }
        @catch (NSException *exception)
        {
            NSLog(@"%s: exception on download image: %@", __func__, exception);
        }
    });
}

- (void)uploadImageWithProfileId:(NSInteger)profileId
                     profileType:(AvatarImageType)type
                        fileName:(NSString *)fileName
                        cacheKey:(NSString *)cacheKey
                           image:(UIImage *)image
                  isCoverPicture:(BOOL)isCoverPicture
                      completion:(void (^)(UpdateMessage *message))completion
{
    fTRACE(@"%@ <Identifier: %ld>", UPLOADUSERPICTURE_ENDPOINT, (long)profileId);
    
    NSString *profileType;
    NSString *endpoint;
    
    switch (type)
    {
        case UserAvatar:
            profileType = @"UserId";
            endpoint = UPLOADUSERPICTURE_ENDPOINT;
            break;
        case PetAvatar:
            profileType = @"PetId";
            endpoint = UPLOADPETPICTURE_ENDPOINT;
            break;
            
        default:
            break;
    }
    
    NSString *endPoint = [NSString stringWithFormat:@"%@?%@=%ld&FileName=%@.png&IsCoverPic=%@",
                          endpoint, profileType, (long)profileId, fileName, isCoverPicture ? @"true" : @"false"];
    NSString *url = [[UrlManager sharedInstance] webServiceUrl:endPoint];
    NSData *data = UIImageJPEGRepresentation(image, kImageCompressionRatio);
    WebClient *webClient = [WebClient new];
    webClient.contentType = CONTENT_TYPE_OCTET_STREAM;
    webClient.timeOut = WEBCLINET_UPLOAD_TIMEOUT;
    self.jsonModel = [UpdateMessage class];
    self.callback = nil;
    webClient.delegate = nil;
    
    if ([[EGOCache globalCache] hasCacheForKey:cacheKey] && ![Utils isNullOrEmpty:cacheKey])
    {
        NSData *imageData = UIImageJPEGRepresentation(image, kImageCompressionRatio);
        [[EGOCache globalCache] setData:imageData forKey:cacheKey];
    }
    
    [webClient post:url postData:data queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      
      @try
      {
          if ([self.jsonModel isSubclassOfClass:[RepositoryObject class]])
          {
              NSError *error = nil;
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
              fTRACE("Response JSON: %@", json);
              
              if (json)
              {
                  ResponseObject *responseObj = [[ResponseObject alloc] initWithDictionary:json error:&error];
                  
                  if (!responseObj)
                  {
                      fTRACE("%s: Can't parse the ResponseObject: %@", __func__, error);
                  }
                  else
                  {
                      UpdateMessage * updateMessage = (UpdateMessage *)[[[self.jsonModel class] alloc] initWithDictionary:responseObj.results[0]
                                                                                                                    error:&error];
                      if (updateMessage && [updateMessage isValidate])
                      {
                          fTRACE("Message: %@", updateMessage.message);
                          completion(updateMessage);
                      }
                  }
              }
          }
      }
      @catch (NSException *exception)
      {
          NSLog(@"%s: exception occurred: %@", __func__, exception);
      }
  }];
    
}

@end
