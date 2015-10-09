//
//  testHttpClient.m
//  pet2share
//
//  Created by Tony Kieu on 7/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Pet2ShareService.h"
#import "Logger.h"

@interface testHttpClient : XCTestCase <Pet2ShareServiceCallback>

@property (nonatomic, strong) XCTestExpectation *expectation;

@end

@implementation testHttpClient

static CGFloat const kRequestTimeOut = 30.0f;

#pragma mark - Life Cycle

- (void)setUp
{
    [super setUp];
    _expectation = nil;
}

- (void)tearDown
{
    [super tearDown];
    self.expectation = nil;
}

#pragma mark - Login Unit Tests

- (void)testLogin
{
    self.expectation = [self expectationWithDescription:@"Response Test"];
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service loginUser:self username:@"Test" password:@"Test"];
    
    [self waitForExpectationsWithTimeout:kRequestTimeOut handler:^(NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    XCTAssert(YES, @"Passed");
}

- (void)testRegister
{
    self.expectation = [self expectationWithDescription:@"Response Test"];
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service registerUser:self firstname:@"Nish" lastname:@"Rathi" username:@"nish@gmail.com" password:@"test" phone:nil];
    
    [self waitForExpectationsWithTimeout:kRequestTimeOut handler:^(NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    XCTAssert(YES, @"Passed");
}

- (void)testGetUserProfile
{
    self.expectation = [self expectationWithDescription:@"Response Test"];
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service getUserProfile:self userId:10];
    
    [self waitForExpectationsWithTimeout:kRequestTimeOut handler:^(NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    XCTAssert(YES, @"Passed");
}

#pragma mark - <Pet2ShareServiceCallback>

- (void)onReceiveSuccess:(NSArray *)objects
{
    fTRACE("Object: %@", objects);
    [self.expectation fulfill];
    XCTAssert(YES, @"Passed");
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    fTRACE("ErrorMessage: %@", errorMessage);
    [self.expectation fulfill];
    XCTAssert(NO, @"Failed");
}

@end