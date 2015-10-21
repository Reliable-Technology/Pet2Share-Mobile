//
//  CollectionViewController.h
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewLayout.h"
#import "EmptyDataView.h"

@interface CollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSString *cellReuseIdentifier;
@property (nonatomic, strong) NSString *customNibName;
@property (nonatomic, strong) EmptyDataView *emptyDataView;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)setupLayout;
- (void)didScrollOutOfBound;

@end
