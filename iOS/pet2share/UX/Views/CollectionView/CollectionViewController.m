//
//  CollectionViewController.m
//  pet2share
//
//  Created by Tony Kieu on 8/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewController.h"
#import "AppColor.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _items = [NSMutableArray array];
        _cellReuseIdentifier = kEmptyString;
        _dataEmptyString = NSLocalizedString(@"Data Not Available", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [AppColorScheme clear];
    self.collectionView.alwaysBounceVertical = YES;
    
    [self setupLayout];
    
    // Custom Nib
    if (self.customNibName)
    {
        [self.collectionView registerNib:[UINib nibWithNibName:self.customNibName bundle:[NSBundle mainBundle]]
              forCellWithReuseIdentifier:self.cellReuseIdentifier];
    }
}

- (void)dealloc
{
    TRACE_HERE;
    self.items = nil;
    self.cellReuseIdentifier = nil;
    self.customNibName = nil;
    self.refreshControl = nil;
}

#pragma mark - Protected Instance Methods

- (void)setupLayout {}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count];
}

@end