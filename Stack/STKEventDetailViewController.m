//
//  STKEventDetailViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventDetailViewController.h"
#import "STKEventPoolsViewController.h"
#import "STKEventBracketsListViewController.h"
#import "STKEventCrossoversViewController.h"

#import "STKEventDetailViewModel.h"

#import "STKEvent.h"
#import "STKEventGroup.h"

#import "STKAttributes.h"
#import "UIColor+STKStyle.h"
#import "UIBarButtonItem+STKExtensions.h"
#import "STKListBackgroundDefaultContentView.h"

#import <KVOController/FBKVOController.h>
#import <RZUtils/RZCommonUtils.h>
#import <RZDataBinding/RZDataBinding.h>

@interface STKEventDetailViewController ()

@property (strong, nonatomic) UIViewController *currentViewController;
@property (strong, nonatomic) STKEventPoolsViewController *poolsViewController;
@property (strong, nonatomic) STKEventBracketsListViewController *bracketsListViewController;
@property (strong, nonatomic) STKEventCrossoversViewController *crossoversViewController;
@property (strong, nonatomic) STKEventDetailViewModel *viewModel;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSLayoutConstraint *containerViewHeight;
@property (strong, nonatomic) UILabel *roundLabel;
@property (strong, nonatomic) UISegmentedControl *roundSegmentedControl;
@property (strong, nonatomic) UIActivityIndicatorView *navigationBarSpinner;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) STKListBackgroundDefaultContentView *emptyStateView;

@end

@implementation STKEventDetailViewController

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventDetailViewModel alloc] initWithEventGroup:group];
        self.poolsViewController = [[STKEventPoolsViewController alloc] initWithEventGroup:self.viewModel.group];
        self.bracketsListViewController = [[STKEventBracketsListViewController alloc] initWithEventGroup:self.viewModel.group];
        self.crossoversViewController = [[STKEventCrossoversViewController alloc] initWithEventGroup:self.viewModel.group];

        self.title = group.event.name;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor stk_backgroundColor];

    [self setupBarButtonItems];
    [self setupContainerView];
    [self setupRoundLabel];
    [self setupRoundSegmentedControl];
    [self setupEmptyStateView];
    [self setupSpinner];

    [self updateSegmentedControlWithSegmentTypes:self.viewModel.segmentTypes];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:NO animated:YES];

    [self setupObservers];
}

#pragma mark - Setup

- (void)setupBarButtonItems {
    self.navigationBarSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationBarSpinner.color = [UIColor whiteColor];
    self.navigationBarSpinner.hidesWhenStopped = YES;

    UIBarButtonItem *spinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navigationBarSpinner];
    self.navigationItem.rightBarButtonItem = spinnerBarButtonItem;
}

- (void)setupContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];

    self.containerView.backgroundColor = [UIColor stk_stackColor];

    self.containerViewHeight = [self.containerView.heightAnchor constraintEqualToConstant:44.0f];
    self.containerViewHeight.active = YES;

    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:topInset].active = YES;
    [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
}

- (void)setupRoundLabel {
    self.roundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.roundLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.roundLabel];

    [self.roundLabel.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor].active = YES;
    [self.roundLabel.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor].active = YES;
}

- (void)setupRoundSegmentedControl {
    self.roundSegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    self.roundSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.roundSegmentedControl];

    [self.roundSegmentedControl addTarget:self action:@selector(didTapSegmentedControl:) forControlEvents:UIControlEventValueChanged];

    NSArray *constraints = @[[self.roundSegmentedControl.heightAnchor constraintEqualToConstant:29.0f],
                             [self.roundSegmentedControl.topAnchor constraintLessThanOrEqualToAnchor:self.containerView.topAnchor constant:7.5f],
                             [self.roundSegmentedControl.leadingAnchor constraintLessThanOrEqualToAnchor:self.containerView.leadingAnchor constant:7.5f],
                             [self.containerView.trailingAnchor constraintLessThanOrEqualToAnchor:self.roundSegmentedControl.trailingAnchor constant:7.5f],
                             [self.containerView.bottomAnchor constraintLessThanOrEqualToAnchor:self.roundSegmentedControl.bottomAnchor constant:7.5f]];

    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setupEmptyStateView {
    self.emptyStateView = [[STKListBackgroundDefaultContentView alloc] init];
    self.emptyStateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.emptyStateView];

    [self.emptyStateView setTitle:@"No Schedule Available" forState:STKListBackgroundViewStateEmpty];
    [self.emptyStateView setMessage:@"Pools, crossovers, and brackets have not yet been created for this event" forState:STKListBackgroundViewStateEmpty];
    [self.emptyStateView setImage:[UIImage imageNamed:@"Events Large"] forState:STKListBackgroundViewStateEmpty];
    [self.emptyStateView updateState:STKListBackgroundViewStateEmpty];
    self.emptyStateView.hidden = YES;

    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    [self.emptyStateView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:topInset].active = YES;
    [self.emptyStateView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.emptyStateView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.emptyStateView.bottomAnchor constant:bottomInset].active = YES;
}

- (void)setupSpinner {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.spinner];

    self.spinner.color = [UIColor stk_stackColor];
    self.spinner.hidesWhenStopped = YES;

    [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)setupObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;

    __weak __typeof(self) wself = self;

    [self.KVOController observe:self.viewModel keyPath:RZDB_KP_OBJ(self.viewModel, downloading) options:options block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *downloading = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

            if (downloading.boolValue) {
                [wself.spinner startAnimating];
                [wself.navigationBarSpinner startAnimating];
            }
            else {
                [wself.spinner stopAnimating];
                [wself.navigationBarSpinner stopAnimating];
                [wself updateEmptyState];
            }
        });
    }];

    [self.KVOController observe:self.viewModel keyPath:RZDB_KP_OBJ(self.viewModel, segmentTypes) options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        NSArray *segmentTypes = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

        [wself updateSegmentedControlWithSegmentTypes:segmentTypes];
    }];
}

#pragma mark - Actions

- (void)updateEmptyState {
    self.emptyStateView.hidden = (self.viewModel.segmentTypes.count > 0);
}

- (void)updateSegmentedControlWithSegmentTypes:(NSArray *)segmentTypes {
    [self.roundSegmentedControl removeAllSegments];

    [segmentTypes enumerateObjectsUsingBlock:^(NSNumber *type, NSUInteger idx, BOOL *stop) {
        NSString *title = [self.viewModel titleForSegmentType:type.integerValue];
        [self.roundSegmentedControl insertSegmentWithTitle:title atIndex:idx animated:NO];
    }];

    if (segmentTypes.count > 1) {
        self.roundLabel.hidden = YES;
        self.roundLabel.attributedText = nil;

        self.roundSegmentedControl.hidden = NO;
    }
    else if (segmentTypes.count == 1) {
        self.roundLabel.hidden = NO;

        NSString *title = [self.viewModel titleForSegmentType:[segmentTypes.firstObject integerValue]];
        NSDictionary *attributes = [STKAttributes stk_eventsFilterTitleAttributes];

        self.roundLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];

        self.roundSegmentedControl.hidden = YES;
    }
    else {
        self.roundLabel.hidden = YES;
        self.roundLabel.attributedText = nil;

        self.roundSegmentedControl.hidden = YES;
    }

    self.containerViewHeight.constant = (segmentTypes.count > 0) ? 44.0f : 0.0f;

    self.roundSegmentedControl.selectedSegmentIndex = 0;
    [self didTapSegmentedControl:self.roundSegmentedControl];
}

- (void)didTapSegmentedControl:(UISegmentedControl *)segmentedControl {
    NSUInteger index = (NSUInteger)segmentedControl.selectedSegmentIndex;

    if (index < self.viewModel.segmentTypes.count) {
        STKEventDetailSegmentType type = [self.viewModel.segmentTypes[index] integerValue];
        UIViewController *viewController = nil;

        switch (type) {
            case STKEventDetailSegmentTypePools:
                viewController = self.poolsViewController;
                break;

            case STKEventDetailSegmentTypeCrossovers:
                viewController = self.crossoversViewController;
                break;

            case STKEventDetailSegmentTypeBrackets:
                viewController = self.bracketsListViewController;
                break;
        }

        if (viewController) {
            [self showViewController:viewController];
        }
    }
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
    [self.view.bottomAnchor constraintLessThanOrEqualToAnchor:viewController.view.bottomAnchor constant:bottomInset].active = YES;

    [viewController didMoveToParentViewController:self];
}

@end
