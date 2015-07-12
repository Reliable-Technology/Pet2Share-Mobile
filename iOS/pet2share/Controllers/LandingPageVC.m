//
//  LandingPageVC.m
//  pet2share
//
//  Created by Tony Kieu on 7/7/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "LandingPageVC.h"
#import "IntroPageContentVC.h"

@interface LandingPageVC () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *introPagesCtrl;
@property (readonly, nonatomic) NSArray *introPageContent;

@end

@implementation LandingPageVC

@synthesize introPageContent = _introPageContent;

static NSString * const kIntroPageTitleKey          = @"intropagetitle";
static NSString * const kIntroPageSubtitleKey       = @"intropagesubtitle";
static NSString * const kIntroPageBgImageNameKey    = @"intropagebgimage";

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the view with introduction images
    IntroPageContentVC *startCtrl = [self pageContentAtIndex:0];
    NSArray *controllers = @[startCtrl];
    [self.introPagesCtrl setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // TODO: Google Analytics
}

- (void)dealloc
{
    TRACE_HERE;
    self.introPagesCtrl = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kIntroPagesView] && !self.introPagesCtrl)
    {
        _introPagesCtrl = (UIPageViewController *)segue.destinationViewController;
        self.introPagesCtrl.dataSource = self;
    }
}

#pragma mark - Private Instance Methods

- (NSArray *)introPageContent
{
    if (!_introPageContent)
    {
        _introPageContent = @[ @{ kIntroPageTitleKey: @"Title 1",
                                  kIntroPageSubtitleKey: @"Subtitle 1",
                                  kIntroPageBgImageNameKey: @"img-intro.png" },
                               @{ kIntroPageTitleKey: @"Title 2",
                                  kIntroPageSubtitleKey: @"Subtitle 2",
                                  kIntroPageBgImageNameKey: @"img-intro.png" },
                               @{ kIntroPageTitleKey: @"Title 3",
                                  kIntroPageSubtitleKey: @"Subtitle 3",
                                  kIntroPageBgImageNameKey: @"img-intro.png" } ];
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
    
    IntroPageContentVC *pageContentCtrl;
    @try
    {
        NSDictionary *dict = [self.introPageContent objectAtIndex:index];
        pageContentCtrl = [[IntroPageContentVC alloc] initWithTitle:dict[kIntroPageTitleKey]
                                                           subTitle:dict[kIntroPageSubtitleKey]
                                                        bgImageName:dict[kIntroPageBgImageNameKey]];
        pageContentCtrl.pageIndex = index;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s - Exception: %@", __func__, [exception description]);
        pageContentCtrl = [[IntroPageContentVC alloc] initWithTitle:kEmptyString subTitle:kEmptyString bgImageName:kEmptyString];
    }

    return pageContentCtrl;
}

#pragma mark - <UIPageViewControllerDataSource>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentVC *) viewController).pageIndex;
    if (index == 0 || index == NSNotFound) return nil;
    index--;
    return [self pageContentAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
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
    return 0;
}

@end
