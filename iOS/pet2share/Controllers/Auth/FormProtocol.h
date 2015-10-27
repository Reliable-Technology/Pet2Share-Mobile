//
//  FormProtocol.h
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

@protocol FormProtocol <NSObject>

@required
- (void)performAction;

@optional
- (void)fieldIsDirty;
- (void)performAction:(id)data;
- (void)updateData:(NSString *)key value:(NSString *)value;

@end