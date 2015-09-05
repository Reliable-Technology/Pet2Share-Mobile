//
//  RepositoryObject.h
//  pet2share
//
//  Created by Tony Kieu on 7/20/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "JSONModel.h"

/*!
 *  @class      RepositoryObject
 *
 *  @discussion This is the abstract class for all the response object. This class contains
 *              all abstract methods that will be implemented at concrete classes.
 *
 */
@interface RepositoryObject : JSONModel

/*!
 *  @property searchable
 *
 *  @discussion A static dictionary of sortable elements.
 */
+ (NSDictionary *)sortableMap;

/*!
 *  @property searchable
 *
 *  @discussion A static dictionary of sortable element keys.
 */
+ (NSDictionary *)sortableKeys;

/*!
 *  @property uniqueId
 *
 *  @discussion The object unique id.
 */
@property (readonly) NSString *uniqueId;

/*!
 *  @property searchable
 *
 *  @discussion A collection tag string used for filtering.
 */
@property (readonly) NSString *filterTags;

/*!
 *  @method validateObject:
 *
 *  @discussion This method returns to false as default. Implement at subclass for model verification.
 *
 */
- (BOOL)validateObject;

@end
