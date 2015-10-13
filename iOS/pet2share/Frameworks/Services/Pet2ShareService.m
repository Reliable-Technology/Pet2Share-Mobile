//
//  Pet2ShareService.m
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <EGOCache/EGOCache.h>
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

- (void)requestData:(NSObject<Pet2ShareServiceCallback> *)callback
           endPoint:(NSString *)endPoint
          jsonModel:(Class)model
           postData:(NSDictionary *)postData
{
    HttpClient *client = [HttpClient baseUrl:[[UrlManager sharedInstance] webServiceUrl]];
    self.jsonModel = model;
    
    [client post:endPoint data:postData
        callback:[HttpCallback callbackWithResult:^(HttpResponse *response) {
        [self parseResponse:response callback:callback];
    }]];
}

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
            fTRACE(@"Response JSON: %@", response.json);
            
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
    fTRACE("%@ <Username: %@ - Password: %@>", LOGIN_ENDPOINT, username, password);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:ObjectOrNull(username) forKey:@"UserName"];
    [postData setObject:ObjectOrNull(password) forKey:@"Password"];
    
    [self requestData:callback endPoint:LOGIN_ENDPOINT jsonModel:[User class] postData:postData];
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
    
    [self requestData:callback endPoint:REGISTER_ENDPOINT jsonModel:[User class] postData:postData];
}

- (void)getUserProfile:(NSObject<Pet2ShareServiceCallback> *)callback userId:(NSInteger)userId
{
    fTRACE(@"%@ <Identifier: %ld>", GETUSERPROFILE_ENDPOINT, userId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(userId) forKey:@"UserId"];
    
    [self requestData:callback endPoint:GETUSERPROFILE_ENDPOINT jsonModel:[User class] postData:postData];
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
    fTRACE(@"%@ <Identifier: %ld>", UPDATEUSERPROFILE_ENDPOINT, userId);
    
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
    
    [self requestData:callback endPoint:UPDATEUSERPROFILE_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)insertPetProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                   petId:(NSInteger)petId
                  userId:(NSInteger)userId
                    name:(NSString *)name
              familyName:(NSString *)familyName
                 petType:(PetType *)petType
             dateOfBirth:(NSDate *)dateOfBirth
                   about:(NSString *)about
                 favFood:(NSString *)favFood
{
    fTRACE(@"%@ <Identifier: %ld>", INSERTPETPROFILE_ENDPOINT, userId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(petId) forKey:@"PetId"];
    [postData setObject:@(userId) forKey:@"UserId"];
    [postData setObject:ObjectOrNull(name) forKey:@"Name"];
    [postData setObject:ObjectOrNull(familyName) forKey:@"FamilyName"];
    [postData setObject:ObjectOrNull(petType) forKey:@"PetTypeId"];
    [postData setObject:[Utils formatNSDateToDateTime:dateOfBirth] forKey:@"DOB"];
    [postData setObject:ObjectOrNull(about) forKey:@"About"];
    [postData setObject:ObjectOrNull(favFood) forKey:@"FavFood"];
    
    [self requestData:callback endPoint:INSERTPETPROFILE_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
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
    fTRACE(@"%@ <Identifier: %ld>", UPDATEPETPROFILE_ENDPOINT, userId);
    
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    [postData setObject:@(petId) forKey:@"PetId"];
    [postData setObject:@(userId) forKey:@"UserId"];
    [postData setObject:ObjectOrNull(name) forKey:@"Name"];
    [postData setObject:ObjectOrNull(familyName) forKey:@"FamilyName"];
    [postData setObject:ObjectOrNull(petType) forKey:@"PetTypeId"];
    [postData setObject:[Utils formatNSDateToDateTime:dateOfBirth] forKey:@"DOB"];
    [postData setObject:ObjectOrNull(about) forKey:@"About"];
    [postData setObject:ObjectOrNull(favFood) forKey:@"FavFood"];
    
    [self requestData:callback endPoint:UPDATEPETPROFILE_ENDPOINT jsonModel:[UpdateMessage class] postData:postData];
}

- (void)loadImage:(NSString *)url
       completion:(void (^)(UIImage* image))completion
{
    if (!url) return;
    
    if ([[EGOCache globalCache] hasCacheForKey:url])
    {
        NSData *data = [[EGOCache globalCache] dataForKey:url];
        UIImage *image = [UIImage imageWithData:data];
        completion(image);
        return;
    }
    
    dispatch_queue_t imageQueue = dispatch_queue_create("imageDownloader", nil);
    dispatch_async(imageQueue, ^{
        @try
        {
            NSURL *imageUrl = [NSURL URLWithString:url];
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

@end
