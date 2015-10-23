//
//  Pet2ShareService.h
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSConstants.h"

typedef NS_ENUM(NSInteger, CachePolicy)
{
    CacheDefault,
    NoCache,
    NotExpired,
    ForceRefresh
};

typedef NS_ENUM(NSInteger, AvatarImageType)
{
    UserAvatar,
    PetAvatar
};

@protocol Pet2ShareServiceCallback <NSObject>

- (void)onReceiveSuccess:(NSArray *)objects;
- (void)onReceiveError:(ErrorMessage *)errorMessage;

@end

@interface Pet2ShareService : NSObject

+ (Pet2ShareService *)sharedService;

- (void)loginUser:(NSObject<Pet2ShareServiceCallback> *)callback
     username:(NSString *)username
     password:(NSString *)password;

- (void)registerUser:(NSObject<Pet2ShareServiceCallback> *)callback
           firstname:(NSString *)firstname
            lastname:(NSString *)lastname
            username:(NSString *)username
            password:(NSString *)password
               phone:(NSString *)phone;

- (void)getUserProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                userId:(NSInteger)userId
           cachePolicy:(CachePolicy)cachePolicy;

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
                  zipCode:(NSString *)zipCode;

- (void)insertPetProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                  userId:(NSInteger)userId
                    name:(NSString *)name
              familyName:(NSString *)familyName
                 petType:(PetType *)petType
             dateOfBirth:(NSDate *)dateOfBirth
                   about:(NSString *)about
                 favFood:(NSString *)favFood;

- (void)updatePetProfile:(NSObject<Pet2ShareServiceCallback> *)callback
                  petId:(NSInteger)petId
                  userId:(NSInteger)userId
                    name:(NSString *)name
              familyName:(NSString *)familyName
                 petType:(PetType *)petType
             dateOfBirth:(NSDate *)dateOfBirth
                   about:(NSString *)about
                 favFood:(NSString *)favFood;

- (void)getPostsByUser:(NSObject<Pet2ShareServiceCallback> *)callback
                userId:(NSInteger)userId
             postCount:(NSInteger)postCount
            pageNumber:(NSInteger)pageNumber;

- (void)getPostsByPet:(NSObject<Pet2ShareServiceCallback> *)callback
                petId:(NSInteger)petId
            postCount:(NSInteger)postCount
           pageNumber:(NSInteger)pageNumber;

- (void)addPost:(NSObject<Pet2ShareServiceCallback> *)callback
postDescription:(NSString *)postDescription
       postedBy:(NSInteger)userId
    isPostByPet:(BOOL)isPostedByPet;

- (void)addPhotoPost:(NSObject<Pet2ShareServiceCallback> *)callback
         description:(NSString *)description
            postedBy:(NSInteger)profileId
         isPostByPet:(BOOL)isPostedByPet
               image:(UIImage *)image
            fileName:(NSString *)fileName;

- (void)updatePost:(NSObject<Pet2ShareServiceCallback> *)callback
            postId:(NSInteger)postId
   postDescription:(NSString *)postDescription;

- (void)deletePost:(NSObject<Pet2ShareServiceCallback> *)callback
            postId:(NSInteger)postId;

- (void)getComments:(NSObject<Pet2ShareServiceCallback> *)callback
             postId:(NSInteger)postId;

- (void)addComment:(NSObject<Pet2ShareServiceCallback> *)callback
            postId:(NSInteger)postId
       commentById:(NSInteger)userId
  isCommentedByPet:(BOOL)isCommentedByPet
commentDescription:(NSString *)commentDescription;

- (void)updateComment:(NSObject<Pet2ShareServiceCallback> *)callback
            commentId:(NSInteger)commentId
   commentDescription:(NSString *)commentDescription;

- (void)deleteComment:(NSObject<Pet2ShareServiceCallback> *)callback
            commentId:(NSInteger)commentId;

- (void)loadImage:(NSString *)url
       completion:(void (^)(UIImage* image))completion;

- (void)uploadImageWithProfileId:(NSInteger)profileId
                     profileType:(AvatarImageType)type
                        fileName:(NSString *)fileName
                        cacheKey:(NSString *)cacheKey
                           image:(UIImage *)image
                  isCoverPicture:(BOOL)isCoverPicture
                      completion:(void (^)(NSString* imageUrl))completion;

@end
