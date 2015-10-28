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

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.baseNavProtocol = self;
        _avatarImgUrl = kEmptyString;
        _avatarBtn = [Graphics circleImageButton:28.0f
                                           image:[UIImage imageNamed:@"img-avatar"]
                                     borderColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup navigation title
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [AppColor navigationBarTextColor],
       NSFontAttributeName:[UIFont fontWithName:kLogoTypeface size:20.0f]}];
    
    // Load avatar image
    [self loadAvatarButtonImage];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueComment] && [sender isKindOfClass:[Post class]])
    {
        UINavigationController *navController = segue.destinationViewController;
        navController.transitioningDelegate = self.transitionZoom;
        CommentVC *commentVC = (CommentVC *)navController.topViewController;
        if (commentVC) commentVC.post = (Post *)sender;
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

#pragma mark - Private Instance Methods

- (void)loadAvatarButtonImage
{
    UIImage *sessionAvatarImage;
    
    if (![Pet2ShareUser current].selectedPet)
    {
        self.avatarImgUrl = [Pet2ShareUser current].person.profilePictureUrl;
        sessionAvatarImage = [Pet2ShareUser current].getUserSessionAvatarImage;
        if (sessionAvatarImage)
        {
            [self.avatarBtn setBackgroundImage:sessionAvatarImage forState:UIControlStateNormal];
            [self.avatarBtn setBackgroundImage:sessionAvatarImage forState:UIControlStateHighlighted];
            return;
        }
    }
    else
    {
        Pet *selectedPet = [Pet2ShareUser current].selectedPet;
        sessionAvatarImage = [[Pet2ShareUser current] getPetSessionAvatarImage:selectedPet.identifier];
        
        self.avatarImgUrl = selectedPet.profilePictureUrl;
        if (sessionAvatarImage)
        {
            [self.avatarBtn setBackgroundImage:sessionAvatarImage forState:UIControlStateNormal];
            [self.avatarBtn setBackgroundImage:sessionAvatarImage forState:UIControlStateHighlighted];
            return;
        }
    }
    
    Pet2ShareService *service = [Pet2ShareService new];
    [service loadImage:self.avatarImgUrl aspectRatio:Square completion:^(UIImage *image) {
        if (!image) image = [UIImage imageNamed:@"img-avatar"];
        [self.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.avatarBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    }];
}

#pragma mark - Delegates

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
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self.feedCollection refreshData];
    });
}

@end