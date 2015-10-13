//
//  Pet2ShareService.h
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSConstants.h"

@protocol Pet2ShareServiceCallback <NSObject>

- (void)onReceiveSuccess:(NSArray *)objects;
- (void)onReceiveError:(ErrorMessage *)errorMessage;

@end

@interface Pet2ShareService : NSObject

@property (nonatomic, strong) Class jsonModel;

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
                userId:(NSInteger)userId;

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

- (void)loadImage:(NSString *)url
       completion:(void (^)(UIImage* image))completion;

@end
