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

static NSString * const kSTKUserDefaultsKeyShownOnboarding = @"com.bradsmith.stack.userDefaults.shownOnboarding";

@interface STKRootViewController () <STKOnboardingPageViewControllerDelegate>

@property (strong, nonatomic) UIViewController *currentViewController;

@property (assign, nonatomic) BOOL shownOnboarding;

@end

@implementation STKRootViewController

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.currentViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.currentViewController;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.shownOnboarding) {
        [self showOnboardingPageViewController];
    }
    else {
        [self showTabBarController];
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
