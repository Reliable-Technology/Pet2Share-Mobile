//
//  ErrorMessage.h
//  pet2share
//
//  Created by Tony Kieu on 10/5/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "RepositoryObject.h"
#import "WSConstants.h"

@interface ErrorMessage : RepositoryObject

@property NSString *message;
@property NSInteger reasonCode;

@end
