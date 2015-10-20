//
//  FeedCollectionVC.h
//  pet2share
//
//  Created by Tony Kieu on 10/19/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewController.h"

@protocol FeedCollectionDelegate <NSObject>

@optional
- (void)didSelectItem:(id)item;

@end

@interface FeedCollectionVC : CollectionViewController

@property (nonatomic, weak) id<FeedCollectionDelegate> collectionDelegate;

- (void)refreshData;

@end
