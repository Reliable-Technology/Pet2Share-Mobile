//
//  PostCollectionVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/9/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PostCollectionVC.h"
#import "PostCollectionCell.h"
#import "ActivityView.h"

static NSString * const kCellIdentifier     = @"postcollectioncell";
static NSString * const kCellNibName        = @"PostCollectionCell";

@interface PostCollectionVC ()

@property (nonatomic, strong) ActivityView *activity;

@end

@implementation PostCollectionVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.cellReuseIdentifier = kCellIdentifier;
        self.customNibName = kCellNibName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _activity = [[ActivityView alloc] initWithView:self.collectionView];
    
    for (int i = 0; i < 5; i++)
    {
        [self.items addObject:@"test"];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark - Layout

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    [layout setupLayout:OneColumn cellHeight:[PostCollectionCell cellHeight] spacing:10.0f];
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCollectionCell *cell =
    (PostCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                    forIndexPath:indexPath];
    return cell;
}

@end
