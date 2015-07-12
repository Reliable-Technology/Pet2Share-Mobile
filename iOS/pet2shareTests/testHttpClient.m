//
//  testHttpClient.m
//  pet2share
//
//  Created by Tony Kieu on 7/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HttpClient.h"

@interface testHttpClient : XCTestCase

@property (nonatomic, strong) XCTestExpectation *expectation;
@property (nonatomic, strong) NSString *baseUrl;

@end

@implementation testHttpClient

static CGFloat const kRequestTimeOut = 30.0f;

#pragma mark - Life Cycle

- (void)setUp
{
    [super setUp];
    
    _expectation = nil;
    _baseUrl = @"https://itunes.apple.com";
}

- (void)tearDown
{
    [super tearDown];
    
    self.expectation = nil;
    self.baseUrl = nil;
}

#pragma mark - Unit Tests

- (void)testJsonGetRequest
{
    HttpClient *client = [HttpClient baseUrl:self.baseUrl];
    
    self.expectation = [self expectationWithDescription:@"Response Test"];
    
    [client get:@"search?term=jack+johnson&limit=25" callback:[HttpCallback callbackWithResult:^(HttpResponse *response) {
        if (!response.hasError)
        {
            NSLog(@"JSON: %@", response.json);
        }
        [self.expectation fulfill];
    }]];
    
    [self waitForExpectationsWithTimeout:kRequestTimeOut handler:^(NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    XCTAssert(@"Passed!");
}

#pragma mark - Performance Unit Tests
// TODO: Should I implement this?

//- (void)testPerformanceExample
//{
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
