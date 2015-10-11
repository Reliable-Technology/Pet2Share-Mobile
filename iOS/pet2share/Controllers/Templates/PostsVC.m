//
//  PostsVC.m
//  pet2share
//
//  Created by Tony Kieu on 10/8/15.
//  Copyright © 2015 Pet 2 Share. All rights reserved.
//

#import "PostsVC.h"
#import "PostCollectionCell.h"
#import "Pet2ShareService.h"

static CGFloat kCellSpacing                 = 10.0f;
static NSString * const kCellIdentifier     = @"postcollectioncell";
static NSString * const kCellNibName        = @"PostCollectionCell";

@interface PostsVC () <Pet2ShareServiceCallback>

@end

@implementation PostsVC

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Request Data
    [self requestData];
}

#pragma mark - Layout

- (void)setupLayout
{
    CollectionViewLayout *layout = (CollectionViewLayout *)self.collectionViewLayout;
    [layout setupLayout:OneColumn cellHeight:[PostCollectionCell cellHeight:kCellSpacing] spacing:kCellSpacing];
}

#pragma mark - Web Services

- (void)requestData
{
    // TODO: Hacking, need full implementation here
    if ([self.items count] == 0)
    {
        for (int i = 0; i < 10; i++)
        {
            [self.items addObject:@"Test"];
            [self.collectionView reloadData];
        }
    }
}

- (void)onReceiveSuccess:(NSArray *)objects
{
    // TODO: Implement later
}

- (void)onReceiveError:(ErrorMessage *)errorMessage
{
    // TODO: Implement later
}

#pragma mark - <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PostCollectionCell *cell =
    (PostCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellReuseIdentifier
                                                                    forIndexPath:indexPath];
    
//    @try
//    {
//        ParsePost *post = [self.items objectAtIndex:indexPath.row];
//        [cell setUpView:post];
//    }
//    @catch (NSException *exception)
//    {
//        NSLog(@"%s: Exception: %@", __func__, exception.description);
//    }
    
    return cell;
}

@end
