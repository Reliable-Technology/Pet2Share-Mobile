//
//  FeedVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/12/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "FeedVC.h"
#import "Graphics.h"
#import "AppColor.h"
#import "WSConstants.h"
#import "FeedCollectionVC.h"
#import "Pet2ShareService.h"
#import "Pet2ShareUser.h"
#import "CommentVC.h"
#import "NewPostVC.h"

@interface FeedVC () <BaseNavigationProtocol, FeedCollectionDelegate, NewPostDelegate>

@property (nonatomic, strong) FeedCollectionVC *feedCollection;
@property (strong, nonatomic) UIButton *avatarBtn;
@property (strong, nonatomic) NSString *avatarImgUrl;

@end

@implementation FeedVC

#pragma mark -
#pragma mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.baseNavProtocol = self;
        _avatarImgUrl = [Pet2ShareUser current].person.profilePictureUrl;
        _avatarBtn = [Graphics circleImageButton:28.0f
                                           image:[UIImage imageNamed:@"img-avatar"]
                                     borderColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAvatarButtonImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup navigation title
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueComment] && [sender isKindOfClass:[Post class]])
    {
        CommentVC *commentVC = (CommentVC *)segue.destinationViewController;
        commentVC.post = (Post *)sender;
    }
    else if ([segue.identifier isEqualToString:kSegueNewPost])
    {
        NewPostVC *newPostVC = (NewPostVC *)segue.destinationViewController;
        newPostVC.transitioningDelegate = self.transitionZoom;
        newPostVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:kSegueFeedCollection])
    {
        self.feedCollection = (FeedCollectionVC *)segue.destinationViewController;
        self.feedCollection.collectionDelegate = self;
    }
    else if ([segue.identifier isEqualToString:kSegueProfileSelection])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        navController.transitioningDelegate = self.transitionManager;
    }
}

- (void)dealloc
{
    TRACE_HERE;
}

#pragma mark -
#pragma mark Private Instance Methods

- (void)loadAvatarButtonImage
{
    Pet2ShareService *service = [Pet2ShareService new];
    [service loadImage:self.avatarImgUrl completion:^(UIImage *image) {
        [self.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.avatarBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    }];
}

#pragma mark -
#pragma mark Delegates

- (UIButton *)setupLeftBarButton
{
    return self.avatarBtn;
}

- (UIButton *)setupRightBarButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight);
    [button setImage:[Graphics tintImage:[UIImage imageNamed:@"icon-compose"]
                               withColor:[AppColorScheme white]] forState:UIControlStateNormal];
    return button;
}

- (void)handleLeftButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:kSegueProfileSelection sender:self];
}

- (void)handleRightButtonEvent:(id)sender
{
    [self performSegueWithIdentifier:kSegueNewPost sender:self];
}

- (void)didSelectItem:(id)item
{
    [self performSegueWithIdentifier:kSegueComment sender:item];
}

- (void)didPost
{
    TRACE_HERE;
    [self.feedCollection refreshData];
}

@end