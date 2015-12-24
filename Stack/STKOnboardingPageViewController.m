//
//  STKOnboardingPageViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKOnboardingPageViewController.h"
#import "STKPermissionViewController.h"

#import "STKAnalyticsManager.h"

#import "UIColor+STKStyle.h"

@interface STKOnboardingPageViewController () <UIPageViewControllerDataSource, STKPermissionViewControllerDelegate>

@property (strong, nonatomic) UIButton *skipButton;

@end

@implementation STKOnboardingPageViewController

#pragma mark - Lifecycle

+ (instancetype)onboardingPageViewController {
    STKOnboardingPageViewController *onboardingPageViewController = [[STKOnboardingPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    return onboardingPageViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor stk_backgroundColor];

    STKPermissionViewController *notificationsPermissionViewController = [[STKPermissionViewController alloc] init];
    notificationsPermissionViewController.delegate = self;
    NSArray *viewControllers = @[notificationsPermissionViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    self.dataSource = self;

    [self setupSkipButton];
}

#pragma mark - Setup

- (void)setupSkipButton {
    self.skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.skipButton];

    [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(didTapSkipButton) forControlEvents:UIControlEventTouchUpInside];

    [self.view.bottomAnchor constraintEqualToAnchor:self.skipButton.bottomAnchor constant:25.0f].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.skipButton.trailingAnchor constant:(2 * 25.0f)].active = YES;
}

#pragma mark - Actions

- (void)didTapSkipButton {
    [STKAnalyticsManager logEventDidSkipNotificationsPrettyPlease];

    if ([self.onboardingDelegate respondsToSelector:@selector(onboardingPageViewControllerDidFinish:)]) {
        [self.onboardingDelegate onboardingPageViewControllerDidFinish:self];
    }
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 1;
}

#pragma mark - Permission View Controller Delegate

- (void)permissionViewControllerDidFinish:(STKPermissionViewController *)permissionViewController {
    if ([self.onboardingDelegate respondsToSelector:@selector(onboardingPageViewControllerDidFinish:)]) {
        [self.onboardingDelegate onboardingPageViewControllerDidFinish:self];
    }
}

@end
