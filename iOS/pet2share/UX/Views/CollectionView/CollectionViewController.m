//
//  CollectionViewController.m
//  pet2share
//
//  Created by Tony Kieu on 10/7/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "CollectionViewController.h"
#import "AppColor.h"

@interface CollectionViewController ()
{
    CGFloat _lastContentOffset;
}

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
    
    self.collectionView.showsHorizontalScrollIndicator = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
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
- (void)didScrollOutOfBound {}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.items count];
}

#pragma mark -
#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection = ScrollDirectionNone;
    if (_lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    else if (_lastContentOffset < scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    _lastContentOffset = scrollView.contentOffset.y;
    
    /*
     fTRACE(@"Scroll Direction: %d Content Size: %.2f Offset: %.2f, View Height: %.2f",
     scrollDirection, scrollView.contentSize.height,  _lastContentOffset, self.view.bounds.size.height); */
    
    if (_lastContentOffset > 0)
    {
        CGFloat offset = scrollView.contentSize.height - _lastContentOffset;
        if (scrollDirection == ScrollDirectionDown && offset < self.view.bounds.size.height)
        {
            [self didScrollOutOfBound];
        }
    }
}

@end
