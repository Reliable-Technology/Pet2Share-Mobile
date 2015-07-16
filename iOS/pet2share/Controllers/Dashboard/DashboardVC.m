//
//  DashboardVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "DashboardVC.h"
#import "DashboardCollectionCell.h"
#import "AppColor.h"

@interface DashboardVC () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cellSizes;

- (IBAction)dismissView:(id)sender;

@end

@implementation DashboardVC

static NSString * const kCellIdentifier = @"cellidentifier";
static NSString * const kCellNibName    = @"DashboardCollectionCell";
static NSInteger const kSampleCellCount = 30;

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
    
    [self.view addSubview:self.collectionView];
    
    // TODO: Analytics
}

- (void)dealloc
{
    TRACE_HERE;
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
    _collectionView = nil;
    _cellSizes = nil;
}

#pragma mark - Private Instance Methods

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        // Setup layout
        CHTCollectionViewWaterfallLayout *layout = [CHTCollectionViewWaterfallLayout new];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        // Setup collection view
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [AppColorScheme clear];
        [_collectionView registerNib:[UINib nibWithNibName:kCellNibName bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)cellSizes
{
    if (!_cellSizes)
    {
        _cellSizes = [NSMutableArray array];
        for (NSInteger i = 0; i < kSampleCellCount; i++)
        {
            CGSize size = CGSizeMake(arc4random() % 50 + 50, arc4random() % 50 + 70);
            _cellSizes[i] = [NSValue valueWithCGSize:size];
        }
    }
    return _cellSizes;
}

#pragma mark - Events

- (IBAction)dismissView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kSampleCellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DashboardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                              forIndexPath:indexPath];
    return cell;
}

#pragma mark - <CHTCollectionViewDelegateWaterfallLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellSizes[indexPath.item] CGSizeValue];
}


@end
