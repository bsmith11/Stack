//
//  STKOnboardingPageViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKOnboardingPageViewController.h"
#import "STKPermissionViewController.h"
#import "STKWelcomeViewController.h"

#import "STKAnalyticsManager.h"

#import "UIColor+STKStyle.h"
#import "UIFont+STKStyle.h"

@interface STKOnboardingPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, STKPermissionViewControllerDelegate>

@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *skipButton;

@property (strong, nonatomic) NSArray *onboardingViewControllers;

@end

@implementation STKOnboardingPageViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - Lifecycle

+ (instancetype)onboardingPageViewController {
    STKOnboardingPageViewController *onboardingPageViewController = [[STKOnboardingPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    return onboardingPageViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    STKWelcomeViewController *welcomeViewController = [[STKWelcomeViewController alloc] init];
    STKPermissionViewController *permissionViewController = [[STKPermissionViewController alloc] init];
    permissionViewController.delegate = self;

    self.onboardingViewControllers = @[welcomeViewController, permissionViewController];

    NSArray *viewControllers = @[self.onboardingViewControllers.firstObject];
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];

    self.dataSource = self;
    self.delegate = self;

    [self setupCoverView];
    [self setupNextButton];
    [self setupSkipButton];

    [self showNextButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Cover up the default tap gesture on page control
    [self.view bringSubviewToFront:self.coverView];
    [self.view bringSubviewToFront:self.nextButton];
    [self.view bringSubviewToFront:self.skipButton];
}

#pragma mark - Setup

- (void)setupCoverView {
    self.coverView = [[UIView alloc] initWithFrame:CGRectZero];
    self.coverView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.coverView];

    self.coverView.userInteractionEnabled = YES;
    self.coverView.backgroundColor = [UIColor clearColor];

    NSArray *constraints = @[[self.coverView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                             [self.view.bottomAnchor constraintEqualToAnchor:self.coverView.bottomAnchor],
                             [self.view.trailingAnchor constraintEqualToAnchor:self.coverView.trailingAnchor],
                             [self.coverView.heightAnchor constraintEqualToConstant:37.0f]];

    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupNextButton {
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.nextButton];

    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = [UIFont stk_onboardingActionFont];
    [self.nextButton setTitleColor:[UIColor stk_twitterColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(didTapNextButton) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.contentEdgeInsets = UIEdgeInsetsMake(12.5f + 3.0f, 12.5f, 12.5f, 12.5f);

    NSArray *constraints = @[[self.view.bottomAnchor constraintEqualToAnchor:self.nextButton.bottomAnchor],
                             [self.view.trailingAnchor constraintEqualToAnchor:self.nextButton.trailingAnchor]];

    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupSkipButton {
    self.skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.skipButton];

    [self.skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    self.skipButton.titleLabel.font = [UIFont stk_onboardingActionFont];
    [self.skipButton setTitleColor:[UIColor stk_twitterColor] forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(didTapSkipButton) forControlEvents:UIControlEventTouchUpInside];
    self.skipButton.contentEdgeInsets = UIEdgeInsetsMake(12.5f + 3.0f, 12.5f, 12.5f, 12.5f);

    NSArray *constraints = @[[self.view.bottomAnchor constraintEqualToAnchor:self.skipButton.bottomAnchor],
                             [self.view.trailingAnchor constraintEqualToAnchor:self.skipButton.trailingAnchor]];

    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Actions

- (void)didTapNextButton {
    [self setViewControllers:@[self.onboardingViewControllers.lastObject]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    [self showSkipButton];
}

- (void)didTapSkipButton {
    [STKAnalyticsManager logEventDidSkipNotificationsPrettyPlease];

    if ([self.onboardingDelegate respondsToSelector:@selector(onboardingPageViewControllerDidFinish:)]) {
        [self.onboardingDelegate onboardingPageViewControllerDidFinish:self];
    }
}

- (void)showNextButton {
    self.nextButton.hidden = NO;
    self.skipButton.hidden = YES;
}

- (void)showSkipButton {
    self.nextButton.hidden = YES;
    self.skipButton.hidden = NO;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *previousViewController = nil;
    NSUInteger index = [self.onboardingViewControllers indexOfObject:viewController];

    if (index != NSNotFound && index > 0) {
        previousViewController = self.onboardingViewControllers[index - 1];
    }

    return previousViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *nextViewController = nil;
    NSUInteger index = [self.onboardingViewControllers indexOfObject:viewController];

    if (index != NSNotFound && index < self.onboardingViewControllers.count - 1) {
        nextViewController = self.onboardingViewControllers[index + 1];
    }

    return nextViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - Page View Controller Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (![pageViewController.viewControllers.firstObject isEqual:previousViewControllers.firstObject]) {
        if ([previousViewControllers.firstObject isEqual:self.onboardingViewControllers.firstObject]) {
            self.skipButton.hidden = !completed;
            self.nextButton.hidden = completed;
        }
        else if ([previousViewControllers.firstObject isEqual:self.onboardingViewControllers.lastObject]) {
            self.skipButton.hidden = completed;
            self.nextButton.hidden = !completed;
        }
    }
}

#pragma mark - Permission View Controller Delegate

- (void)permissionViewControllerDidFinish:(STKPermissionViewController *)permissionViewController {
    if ([self.onboardingDelegate respondsToSelector:@selector(onboardingPageViewControllerDidFinish:)]) {
        [self.onboardingDelegate onboardingPageViewControllerDidFinish:self];
    }
}

@end
