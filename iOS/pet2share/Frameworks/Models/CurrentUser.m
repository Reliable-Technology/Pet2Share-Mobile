//
//  CurrentUser.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CurrentUser.h"

static CurrentUser *_shareInstance = nil;

@implementation CurrentUser

+ (CurrentUser *)sharedInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _shareInstance = [CurrentUser new];
    });
    return _shareInstance;
}

- (id)init
{
    if ((self = [super init])) {}
    return self;
}

@end
