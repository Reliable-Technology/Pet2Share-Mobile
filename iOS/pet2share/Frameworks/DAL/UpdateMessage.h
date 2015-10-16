//
//  UpdateMessage.h
//  pet2share
//
//  Created by Tony Kieu on 10/9/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"

@interface UpdateMessage : RepositoryObject

@property BOOL isSuccessful;
@property NSString *message;
@property NSInteger updateId;

@end
