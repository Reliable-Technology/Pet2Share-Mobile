//
//  LandingPageVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "LandingPageVC.h"
#import "IntroPageContentVC.h"
#import "LoginViewCtrl.h"

@interface LandingPageVC () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *introPagesCtrl;
@property (readonly, nonatomic) NSArray *introPageContent;
@property (strong, nonatomic) NSTimer *scrollTimer;
@property (strong, nonatomic) TransitionManager *transitionManager;

- (IBAction)getStartedBtnTapped:(id)sender;

@end

@implementation LandingPageVC
{
    NSInteger _currPageIndex;
}

@synthesize introPageContent = _introPageContent;

static NSString * const kIntroPageTitleKey          = @"intropagetitle";
static NSString * const kIntroPageSubtitleKey       = @"intropagesubtitle";
static NSString * const kIntroPageBgImageNameKey    = @"intropagebgimage";
static CGFloat const kScrollTimer                   = 5.0f;

#pragma mark - Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        _currPageIndex = 0;
        _transitionManager = [TransitionManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize the view with introduction images
    IntroPageContentVC *startCtrl = [self pageContentAtIndex:_currPageIndex];
    [self.introPagesCtrl setViewControllers: @[startCtrl]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO completion:nil];
    
    [self setPeriodicScroll:YES];
    
    // TODO: Google Analytics
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.scrollTimer invalidate];
}

- (void)dealloc
{
    TRACE_HERE;
    self.introPagesCtrl = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegueIntroPages])
    {
        _introPagesCtrl = (UIPageViewController *)segue.destinationViewController;
        self.introPagesCtrl.dataSource = self;
    }
    else if ([segue.identifier isEqualToString:kSegueLogin])
    {
//        LoginViewCtrl *loginCtrl = (LoginViewCtrl *)segue.destinationViewController;
//        loginCtrl.transitioningDelegate = self.transitionManager;
    }
}

#pragma mark - Private Instance Methods

- (NSArray *)introPageContent
{
    if (!_introPageContent)
    {
        _introPageContent = @[ @{ kIntroPageTitleKey: @"Moments",
                                  kIntroPageSubtitleKey: @"Add some pet pictures to your designs and prototypes with placeholder pictures.",
                                  kIntroPageBgImageNameKey: @"img-intro1.png" },
                               @{ kIntroPageTitleKey: @"Social",
                                  kIntroPageSubtitleKey: @"A quick and simple service for getting pictures of kittens for use as placeholders in your designs or code.",
                                  kIntroPageBgImageNameKey: @"img-intro1.png" },
                               @{ kIntroPageTitleKey: @"Networking",
                                  kIntroPageSubtitleKey: @"Get placeholders related to the site you are developing, by pulling images from flickr based on tags.",
                                  kIntroPageBgImageNameKey: @"img-intro1.png" } ];
    }
    return _introPageContent;
}

- (IntroPageContentVC *)pageContentAtIndex:(NSUInteger)index
{
    if (self.introPageContent.count == 0 || index >= self.introPageContent.count)
    {
        // (╯°□°）╯︵ ┻━┻ TIFU
        return nil;
    }
    
    IntroPageContentVC *pageCtrl;
    @try
    {
        NSDictionary *dict = [self.introPageContent objectAtIndex:index];
        pageCtrl = [[IntroPageContentVC alloc] initWithTitle:dict[kIntroPageTitleKey]
                                                    subTitle:dict[kIntroPageSubtitleKey]
                                                 bgImageName:dict[kIntroPageBgImageNameKey]];
        pageCtrl.pageIndex = index;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s - Exception: %@", __func__, [exception description]);
        pageCtrl = [[IntroPageContentVC alloc] initWithTitle:kEmptyString subTitle:kEmptyString bgImageName:kEmptyString];
    }

    return pageCtrl;
}

- (void)setPeriodicScroll:(BOOL)on
{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
    
    if (on)
    {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:kScrollTimer
                                                            target:self
                                                          selector:@selector(loadNextPage)
                                                          userInfo:nil
                                                           repeats:YES];
    }
}

- (void)loadNextPage
{
    @try
    {
        IntroPageContentVC *currPageCtrl = [self pageContentAtIndex:++_currPageIndex];
        if (currPageCtrl == nil)
        {
            _currPageIndex = 0;
            currPageCtrl = [self pageContentAtIndex:_currPageIndex];
        }
        [self.introPagesCtrl setViewControllers:@[currPageCtrl]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES completion:nil];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s - Exception: %@", __func__, [exception description]);
    }
}

- (IBAction)getStartedBtnTapped:(id)sender
{
    [self performSegueWithIdentifier:kSegueLogin sender:self];
}

#pragma mark - <UIPageViewControllerDataSource>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    [self setPeriodicScroll:NO];
    NSUInteger index = ((IntroPageContentVC *) viewController).pageIndex;
    if (index == 0 || index == NSNotFound) return nil;
    index--;
    return [self pageContentAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    [self setPeriodicScroll:NO];
    NSUInteger index = ((IntroPageContentVC *) viewController).pageIndex;
    if (index == NSNotFound) return nil;
    index++;
    if (index == self.introPageContent.count) return nil;
    return [self pageContentAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.introPageContent.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return _currPageIndex;
}

@end
