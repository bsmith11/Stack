//
//  STKEventDetailViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventDetailViewController.h"
#import "STKEventPoolsViewController.h"
#import "STKEventBracketsViewController.h"
#import "STKEventCrossoversViewController.h"

#import "STKEventDetailViewModel.h"

#import "STKEvent.h"
#import "STKEventGroup.h"

#import "UIColor+STKStyle.h"
#import "UIBarButtonItem+STKExtensions.h"

#import <KVOController/FBKVOController.h>
#import <RZUtils/RZCommonUtils.h>
#import <RZDataBinding/RZDataBinding.h>

@interface STKEventDetailViewController ()

@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) STKEventPoolsViewController *poolsViewController;
@property (strong, nonatomic) STKEventBracketsViewController *bracketsViewController;
@property (strong, nonatomic) STKEventCrossoversViewController *crossoversViewController;
@property (strong, nonatomic) STKEventDetailViewModel *viewModel;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UISegmentedControl *roundSegmentedControl;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation STKEventDetailViewController

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventDetailViewModel alloc] initWithEventGroup:group];
        self.poolsViewController = [[STKEventPoolsViewController alloc] initWithEventGroup:self.viewModel.group];
        self.bracketsViewController = [[STKEventBracketsViewController alloc] initWithEventGroup:self.viewModel.group];
        self.crossoversViewController = [[STKEventCrossoversViewController alloc] initWithEventGroup:self.viewModel.group];

        self.title = group.event.name;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor stk_backgroundColor];

    [self setupBarButtonItems];
    [self setupRoundSegmentedControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:NO animated:YES];

    [self setupObservers];

    [self didTapSegmentedControl:self.roundSegmentedControl];
}

#pragma mark - Setup

- (void)setupBarButtonItems {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.color = [UIColor whiteColor];
    self.spinner.hidesWhenStopped = YES;

    UIBarButtonItem *spinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    self.navigationItem.rightBarButtonItem = spinnerBarButtonItem;
}

- (void)setupRoundSegmentedControl {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];

    self.containerView.backgroundColor = [UIColor stk_stackColor];

    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:topInset].active = YES;
    [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;

    self.roundSegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    self.roundSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.roundSegmentedControl];

    [self.roundSegmentedControl insertSegmentWithTitle:@"Pools" atIndex:0 animated:NO];
    [self.roundSegmentedControl insertSegmentWithTitle:@"Crossovers" atIndex:1 animated:NO];
    [self.roundSegmentedControl insertSegmentWithTitle:@"Brackets" atIndex:2 animated:NO];
    self.roundSegmentedControl.selectedSegmentIndex = 0;
    [self.roundSegmentedControl addTarget:self action:@selector(didTapSegmentedControl:) forControlEvents:UIControlEventValueChanged];

    [self.roundSegmentedControl.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:7.5f].active = YES;
    [self.roundSegmentedControl.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:7.5f].active = YES;
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.roundSegmentedControl.trailingAnchor constant:7.5f].active = YES;
    [self.containerView.bottomAnchor constraintEqualToAnchor:self.roundSegmentedControl.bottomAnchor constant:7.5f].active = YES;
}

- (void)setupObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;

    __weak __typeof(self) wself = self;

    [self.KVOController observe:self.viewModel keyPath:RZDB_KP_OBJ(self.viewModel, downloading) options:options block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *downloading = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

            if (downloading.boolValue) {
                [wself.spinner startAnimating];
            }
            else {
                [wself.spinner stopAnimating];
            }
        });
    }];
}

#pragma mark - Actions

- (void)didTapSegmentedControl:(UISegmentedControl *)segmentedControl {
    UIViewController *viewController = nil;

    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            viewController = self.poolsViewController;
            break;

        case 1:
            viewController = self.crossoversViewController;
            break;

        case 2:
            viewController = self.bracketsViewController;
            break;
    }

    [self showViewController:viewController];
}

- (void)showViewController:(UIViewController *)viewController {
    if (self.currentViewController) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }

    self.currentViewController = viewController;

    [self addChildViewController:viewController];
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:viewController.view];

    [viewController.view.topAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;
    [viewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:viewController.view.trailingAnchor].active = YES;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    [self.view.bottomAnchor constraintEqualToAnchor:viewController.view.bottomAnchor constant:bottomInset].active = YES;

    [viewController didMoveToParentViewController:self];
}

@end
