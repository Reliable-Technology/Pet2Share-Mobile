//
//  PFQueryService.h
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFObject;
@class PFQueryCallback;
@class ParseUser;
@class ParsePet;

@interface PFQueryService : NSObject

+ (void)loadImageFile:(PFFile *)file imageView:(UIImageView *)imageView
           completion:(void (^)(BOOL finished))completion;

+ (void)loadImage:(ParseUser *)object
        imageView:(UIImageView *)imageView;

+ (void)loadImage:(ParseUser *)user
       completion:(void (^)(UIImage* image))completion;

- (void)registerUser:(NSObject<PFQueryCallback> *)callback
            username:(NSString *)username
               email:(NSString *)email
            password:(NSString *)password;

- (void)loginUser:(NSObject<PFQueryCallback> *)callback
         username:(NSString *)username
         password:(NSString *)password;

- (void)getConnections:(NSObject<PFQueryCallback> *)callback
               forUser:(ParseUser *)user;

- (void)getPets:(NSObject<PFQueryCallback> *)callback
        forUser:(ParseUser *)user;

- (void)getPosts:(NSObject<PFQueryCallback> *)callback
          forPet:(ParsePet *)pet;

- (void)addPost:(NSObject<PFQueryCallback> *)callback
          image:(UIImage *)image
           text:(NSString *)text
        forUser:(ParseUser *)user
         forPet:(ParsePet *)pet;

@end
