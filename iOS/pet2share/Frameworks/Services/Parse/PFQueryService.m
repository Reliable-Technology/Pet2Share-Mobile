//
//  PFQueryService.m
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "ParseServices.h"
#import "Logger.h"

@implementation PFQueryService

+ (void)loadImageFile:(PFFile *)file imageView:(UIImageView *)imageView
           completion:(void (^)(BOOL finished))completion
{
    // fTRACE("Object: %@ Image Key: %@", [object description], imageKey);
    
    // If the object contains the file, load the image from the file.
    // Otherwise, try fetching object once then load the image from the file.
    if (file)
    {
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data) [imageView setImage:[UIImage imageWithData:data]];
            else fTRACE("Error Getting Image: %@", [error localizedDescription]);
            if (completion) completion(YES);
        }];
    }
}

+ (void)loadImage:(ParseUser *)user
        imageView:(UIImageView *)imageView
{
    // fTRACE("Object: %@ Image Key: %@", [object description], imageKey);
    
    // Load Image Block
    void (^loadImage)(PFFile *) = ^(PFFile *file) {
        if (file)
        {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data) [imageView setImage:[UIImage imageWithData:data]];
                else fTRACE("Error Getting Image: %@", [error localizedDescription]);
            }];
        }
    };
    
    // If the object contains the file, load the image from the file.
    // Otherwise, try fetching object once then load the image from the file.
    if (user.avatarImage)
    {
        loadImage(user.avatarImage);
    }
    else
    {
        [user fetchInBackgroundWithBlock:^(PFObject *fetchObject, NSError *error) {
            
            if ([fetchObject isKindOfClass:[ParseUser class]])
            {
                ParseUser *fetchUser = (ParseUser *)fetchObject;
                loadImage(fetchUser.avatarImage);
            }
        }];
    }
}

+ (void)loadImage:(ParseUser *)user
       completion:(void (^)(UIImage* image))completion
{
    // fTRACE("Object: %@ Image Key: %@", [object description], imageKey);
    
    // Load Image Block
    void (^loadImage)(PFFile *) = ^(PFFile *file) {
        if (file)
        {
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data) completion([UIImage imageWithData:data]);
                else fTRACE("Error Getting Image: %@", [error localizedDescription]);
            }];
        }
    };
    
    // If the object contains the file, load the image from the file.
    // Otherwise, try fetching object once then load the image from the file.
    if (user.avatarImage)
    {
        loadImage(user.avatarImage);
    }
    else
    {
        [user fetchInBackgroundWithBlock:^(PFObject *fetchObject, NSError *error) {
            
            if ([fetchObject isKindOfClass:[ParseUser class]])
            {
                ParseUser *fetchUser = (ParseUser *)fetchObject;
                loadImage(fetchUser.avatarImage);
            }
        }];
    }
}

- (void)registerUser:(NSObject<PFQueryCallback> *)callback
            username:(NSString *)username
               email:(NSString *)email
            password:(NSString *)password
{
    fTRACE("Username: %@ - Email: %@ - Password: %@", username, email, password);
    
    __block PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) [callback onQuerySuccess:user];
        else [callback onQueryError:error];
    }];
}

- (void)loginUser:(NSObject<PFQueryCallback> *)callback
         username:(NSString *)username
         password:(NSString *)password
{
    fTRACE("Username: %@ - Password: %@", username, password);
    
    [ParseUser logInWithUsernameInBackground:username password:password block:^(id object, NSError *error) {
        if ([object isKindOfClass:[ParseUser class]]) [callback onQuerySuccess:object];
        else [callback onQueryError:error];
    }];
}

- (void)getPets:(NSObject<PFQueryCallback> *)callback
        forUser:(ParseUser *)user
{
    PFQuery *query = [ParsePet query];
    if (user) [query whereKey:kParsePetOwner equalTo:user];
    
    // TODO: Caching & Paging
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) [callback onQueryListSuccess:objects];
        else [callback onQueryError:error];
    }];
}

- (void)getPosts:(NSObject<PFQueryCallback> *)callback
          forPet:(ParsePet *)pet
{
    PFQuery *query = [ParsePost query];
    if (pet) [query whereKey:kParsePostPet equalTo:pet];
    [query includeKey:kParsePostPoster];
    
    // TODO: Caching & Paging
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) [callback onQueryListSuccess:objects];
        else [callback onQueryError:error];
    }];
}

@end