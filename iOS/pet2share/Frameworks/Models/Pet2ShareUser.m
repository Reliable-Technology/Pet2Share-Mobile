//
//  Pet2ShareUser.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "Pet2ShareUser.h"

static Pet2ShareUser *_current = nil;

@implementation Pet2ShareUser

@synthesize identifier = _identifier;
@synthesize username = _username;
@synthesize isAuthenticated = _isAuthenticated;
@synthesize isActive = _isActive;

+ (Pet2ShareUser *)current
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _current = [Pet2ShareUser new];
    });
    return _current;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [Pet2ShareUser current];
}

- (id)init
{
    if ((self = [super init]))
    {
        _person = [Person new];
    }
    return self;
}

- (void)updateFromUser:(User *)user
{
    if (user)
    {
        _identifier = user.identifier;
        _username = user.username;
        self.email = user.email;
        self.alternateEmail = user.alternateEmail;
        self.socialMediaId = user.socialMediaId;
        self.socialMediaName = user.socialMediaName;
        self.phone = user.phone;
        self.socialMediaSource = user.socialMediaSource;
        self.person = user.person;
        self.userType = user.userType;
        _isAuthenticated = user.isAuthenticated;
        _isActive = user.isActive;
    }
}

@end
