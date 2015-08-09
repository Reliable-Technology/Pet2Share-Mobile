//
//  PetPostsVC.m
//  pet2share
//
//  Created by Tony Kieu on 8/8/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "PetPostsVC.h"
#import "PostCollectionVC.h"
#import "ParseServices.h"

static NSString * const kLeftIconImageName  = @"icon-arrowback";

@interface PetPostsVC () <BarButtonsProtocol>

@end

@implementation PetPostsVC

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.barButtonsProtocol = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.pet.nickName ?: NSLocalizedString(@"N/A", @"");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSeguePetPostsContainer])
    {
        PostCollectionVC *collectionController = (PostCollectionVC *)segue.destinationViewController;
        collectionController.pet = self.pet;
    }
}

- (void)dealloc
{
    TRACE_HERE;
    self.pet = nil;
}

#pragma mark - <BarButtonsDelegate>

- (UIButton *)setupLeftBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight);
    [button setImage:[UIImage imageNamed:kLeftIconImageName] forState:UIControlStateNormal];
    return button;
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
