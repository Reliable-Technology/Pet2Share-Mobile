//
//  ResponseObject.h
//  pet2share
//
//  Created by Tony Kieu on 9/5/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "JSONModel.h"

@class ErrorMessage;

@interface ResponseObject : JSONModel

@property ErrorMessage<Optional> *errorMessage;
@property NSInteger total;
@property NSArray<Optional> *results;

@end
