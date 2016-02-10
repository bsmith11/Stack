//
//  STKRootViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKRootViewController.h"
#import "STKOnboardingPageViewController.h"
#import "STKTabBarController.h"

#import "STKLaunchImageView.h"

static NSString * const kSTKUserDefaultsKeyShownOnboarding = @"com.bradsmith.stack.userDefaults.shownOnboarding";

@interface STKRootViewController () <STKOnboardingPageViewControllerDelegate>

@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) STKLaunchImageView *launchImageView;

@property (assign, nonatomic) BOOL shownOnboarding;
@property (assign, nonatomic) BOOL didLayoutSubviews;
@property (assign, nonatomic) BOOL didAppearInitially;

@end

@implementation STKRootViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.currentViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.currentViewController;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.launchImageView = [[STKLaunchImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.launchImageView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        CGFloat width = 150.0f;
        CGFloat height = 150.0f;
        CGFloat x = (CGRectGetWidth(self.view.bounds) - width) / 2;
        CGFloat y = (CGRectGetHeight(self.view.bounds) - height) / 2;

        self.launchImageView.frame = CGRectMake(x, y, width, height);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.didAppearInitially) {
        self.didAppearInitially = YES;

        __weak __typeof(self) wself = self;
        int64_t delay = (int64_t)(0.1 * NSEC_PER_SEC);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [wself.launchImageView animateWithCompletion:^(BOOL finished) {
                if (!wself.shownOnboarding) {
                    [wself showOnboardingPageViewController];
                }
                else {
                    [wself showTabBarController];
                }

                [wself.launchImageView removeFromSuperview];
            }];
        });
    }
}

#pragma mark - Actions

- (void)showOnboardingPageViewController {
    STKOnboardingPageViewController *onboardingPageViewController = [STKOnboardingPageViewController onboardingPageViewController];
    onboardingPageViewController.onboardingDelegate = self;

    [self showViewController:onboardingPageViewController];
}

- (void)showTabBarController {
    STKTabBarController *tabBarController = [[STKTabBarController alloc] init];

    [self showViewController:tabBarController];
}

- (void)showViewController:(UIViewController *)viewController {
    if (self.currentViewController) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }

    self.currentViewController = viewController;

    [self setNeedsStatusBarAppearanceUpdate];

    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    viewController.view.frame = self.view.frame;
    [viewController didMoveToParentViewController:self];
}

- (BOOL)shownOnboarding {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSTKUserDefaultsKeyShownOnboarding];
}

- (void)setShownOnboarding:(BOOL)shownOnboarding {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:shownOnboarding forKey:kSTKUserDefaultsKeyShownOnboarding];
    [userDefaults synchronize];
}

#pragma mark - Onboarding Page View Controller Delgate

- (void)onboardingPageViewControllerDidFinish:(STKOnboardingPageViewController *)onboardingPageViewController {
    self.shownOnboarding = YES;
    
    [self showTabBarController];
}

@end
