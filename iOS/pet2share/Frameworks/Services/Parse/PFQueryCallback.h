//
//  PFQueryCallback.h
//  pet2share
//
//  Created by Tony Kieu on 8/3/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

@class PFObject;

@protocol PFQueryCallback <NSObject>

@required
- (void)onQuerySuccess:(PFObject *)object;
- (void)onQueryError:(NSError *)error;

@end