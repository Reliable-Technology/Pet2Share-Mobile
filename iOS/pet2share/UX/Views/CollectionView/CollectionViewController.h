//
//  CollectionViewController.h
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewLayout.h"

@interface CollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSString *cellReuseIdentifier;
@property (nonatomic, strong) NSString *customNibName;
@property (nonatomic, strong) NSString *dataEmptyString;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)setupLayout;

@end
