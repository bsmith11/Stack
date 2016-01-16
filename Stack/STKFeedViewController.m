//
//  STKFeedViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKFeedViewController.h"
#import "STKPostViewController.h"
#import "STKSourceListViewController.h"

#import "STKFeedViewModel.h"

#import "STKPost.h"

#import "STKPostNode.h"

#import "STKListBackgroundView.h"
#import "STKListBackgroundDefaultContentView.h"
#import "UIColor+STKStyle.h"
#import "UIFont+STKStyle.h"
#import "UIBarButtonItem+STKExtensions.h"
#import "STKAnalyticsManager.h"
#import "STKTableViewDataSource.h"

#import <AsyncDisplayKit/ASTableView.h>
#import <KVOController/FBKVOController.h>
#import <RZDataBinding/RZDataBinding.h>
#import <RZUtils/RZCommonUtils.h>
#import <tgmath.h>
#import <SSPullToRefresh/SSPullToRefresh.h>
#import <pop/POP.h>

@interface STKFeedViewController () <ASTableViewDelegate, STKTableViewDataSourceDelegate, SSPullToRefreshViewDelegate, STKSourceListViewControllerDelegate, STKListBackgroundDefaultContentViewDelegate>

@property (strong, nonatomic) STKSourceListViewController *sourceListViewController;
@property (strong, nonatomic) STKFeedViewModel *viewModel;
@property (strong, nonatomic) ASTableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;
@property (strong, nonatomic) STKListBackgroundView *listBackgroundView;
@property (strong, nonatomic) UIButton *contentButton;

@property (assign, nonatomic) BOOL contentButtonShown;
@property (assign, nonatomic) BOOL shouldRemovePostsBeforeGap;

@end

@implementation STKFeedViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.viewModel = [[STKFeedViewModel alloc] init];
        UIImage *image = [UIImage imageNamed:@"Feed Off Icon"];
        UIImage *selectedImage = [UIImage imageNamed:@"Feed On Icon"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Feed" image:image selectedImage:selectedImage];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupBarButtonItems];
    [self setupTableView];
    [self setupContentButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupObservers];
    [self setupSourceListViewController];

    [self.viewModel setupDataSourceWithTableView:self.tableView delegate:self];

    __weak __typeof(self) wself = self;
    [self.viewModel updatePostsForSourceType:-1 completion:^(STKViewModelFetchResult result) {
        [wself handleNewFetchCompletionWithResult:result];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        self.tableView.frame = self.view.bounds;

        CGFloat x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.contentButton.bounds)) / 2;
        CGFloat y = -CGRectGetHeight(self.contentButton.bounds);

        self.contentButton.frame = CGRectMake(x, y, CGRectGetWidth(self.contentButton.bounds), CGRectGetHeight(self.contentButton.bounds));

        [self setupRefreshView];
        [self setupListBackgroundView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.transitionCoordinator animateAlongsideTransitionInView:self.stk_navigationController.view animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIColor *color = [STKSource colorForType:self.viewModel.sourceType] ?: [UIColor stk_stackColor];
        self.navigationController.navigationBar.barTintColor = color;
        self.contentButton.backgroundColor = color;
    } completion:nil];
}

#pragma mark - Setup

- (void)setupBarButtonItems {
    CGFloat fixedWidth = (12.5f - 16.0f);

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.color = self.navigationController.navigationBar.tintColor;

    UIBarButtonItem *spinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    UIBarButtonItem *leftSpaceBarButtonItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:fixedWidth];
    self.navigationItem.leftBarButtonItems = @[leftSpaceBarButtonItem, spinnerBarButtonItem];

    UIImage *listImage = [UIImage imageNamed:@"List Icon"];
    UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] initWithImage:listImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapListBarButtonItem)];
    UIBarButtonItem *rightSpaceBarButtonItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:fixedWidth];
    self.navigationItem.rightBarButtonItems = @[rightSpaceBarButtonItem, listBarButtonItem];
}

- (void)setupTableView {
    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:YES];
    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(topInset + 6.25f, 0.0f, bottomInset + 6.25f, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.asyncDelegate = self;
    self.tableView.automaticallyAdjustsContentOffset = YES;

    [self.view addSubview:self.tableView];
}

- (void)setupContentButton {
    self.contentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.contentButton];

    [self.contentButton addTarget:self action:@selector(didTapContentButton) forControlEvents:UIControlEventTouchUpInside];
    self.contentButton.backgroundColor = self.navigationController.navigationBar.barTintColor;
    [self.contentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentButton setTitle:@"Tap to view new articles" forState:UIControlStateNormal];
    self.contentButton.titleLabel.font = [UIFont stk_postNodeTitleFont];
    self.contentButton.contentEdgeInsets = UIEdgeInsetsMake(12.0f, 12.0f, 12.0f, 12.0f);
    self.contentButton.layer.cornerRadius = 12.0f;
    self.contentButton.clipsToBounds = YES;

    [self.contentButton sizeToFit];
}

- (void)setupListBackgroundView {
    self.listBackgroundView = [[STKListBackgroundView alloc] initWithTableView:self.tableView];

    STKListBackgroundDefaultContentView *contentView = [[STKListBackgroundDefaultContentView alloc] init];
    contentView.delegate = self;

    [contentView setImage:[UIImage imageNamed:@"Feed Large"] forState:STKListBackgroundViewStateEmpty];
    [contentView setTitle:@"No Content" forState:STKListBackgroundViewStateEmpty];
    [contentView setMessage:@"There doesn't seem to be anything here..." forState:STKListBackgroundViewStateEmpty];

    [contentView setImage:[UIImage imageNamed:@"Error Large"] forState:STKListBackgroundViewStateError];
    [contentView setTitle:@"Network Error" forState:STKListBackgroundViewStateError];
    [contentView setMessage:@"There seems to be a malfunction with the hyperdrive..." forState:STKListBackgroundViewStateError];
    [contentView setActionTitle:@"Try again" forState:STKListBackgroundViewStateError];

    self.listBackgroundView.contentView = contentView;
}

- (void)setupRefreshView {
    if (!self.refreshView) {
        self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
        
        SSPullToRefreshSimpleContentView *contentView = [[SSPullToRefreshSimpleContentView alloc] initWithFrame:CGRectZero];
        contentView.statusLabel.textColor = [UIColor stk_stackColor];
        contentView.activityIndicatorView.color = [UIColor stk_stackColor];

        self.refreshView.contentView = contentView;
    }
}

- (void)setupObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;

    __weak __typeof(self) wself = self;

    [self.KVOController observe:self.viewModel keyPath:RZDB_KP_OBJ(self.viewModel, downloading) options:options block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *downloading = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

            wself.listBackgroundView.loading = downloading.boolValue;

            if (downloading.boolValue) {
                [wself.spinner startAnimating];
                wself.listBackgroundView.state = STKListBackgroundViewStateNone;
            }
            else {
                [wself.spinner stopAnimating];

                if (wself.refreshView.state == SSPullToRefreshViewStateLoading) {
                    BOOL animated = wself.navigationController.topViewController == wself;
                    [wself.refreshView finishLoadingAnimated:animated completion:nil];
                }
            }
        });
    }];

    [self.KVOController observe:self.viewModel keyPath:RZDB_KP_OBJ(self.viewModel, networkError) options:options block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

            if (error) {
                wself.listBackgroundView.state = STKListBackgroundViewStateError;
            }
        });
    }];

    [self rz_bindKey:RZDB_KP_SELF(title) toKeyPath:RZDB_KP_OBJ(self.viewModel, title) ofObject:self.viewModel];
}

- (void)setupSourceListViewController {
    self.sourceListViewController = [[STKSourceListViewController alloc] init];
    self.sourceListViewController.delegate = self;
}

#pragma mark - Actions

- (void)didTapListBarButtonItem {
    [self.navigationController pushViewController:self.sourceListViewController animated:YES];
}

- (void)didTapContentButton {
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = -self.tableView.contentInset.top;
    [self.tableView setContentOffset:contentOffset animated:YES];

    [self hideNewContentView];
}

- (void)showNewContentView {
    if (!self.contentButtonShown) {
        self.contentButtonShown = YES;

        POPSpringAnimation *animation = [self.contentButton pop_animationForKey:@"spring"];
        if (!animation) {
            animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        }

        CGRect frame = self.contentButton.frame;
        frame.origin.y = self.statusBarHeight + self.navigationBarHeight + 20.0f;
        animation.toValue = [NSValue valueWithCGRect:frame];

        [self.contentButton pop_addAnimation:animation forKey:@"spring"];
    }
}

- (void)hideNewContentView {
    if (self.contentButtonShown) {
        self.contentButtonShown = NO;

        POPSpringAnimation *animation = [self.contentButton pop_animationForKey:@"spring"];
        if (!animation) {
            animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        }

        CGRect frame = self.contentButton.frame;
        frame.origin.y = -CGRectGetHeight(self.contentButton.bounds);
        animation.toValue = [NSValue valueWithCGRect:frame];

        [self.contentButton pop_addAnimation:animation forKey:@"spring"];
    }
}

- (void)handleNewFetchCompletionWithResult:(STKViewModelFetchResult)result {
    if (result == STKViewModelFetchResultSuccessNew) {
        [self showNewContentView];
    }
    else if (result == STKViewModelFetchResultSuccessNewGap) {
        self.shouldRemovePostsBeforeGap = YES;

        [self showNewContentView];
    }
}

- (void)removePostsBeforeGap {
    if (self.shouldRemovePostsBeforeGap) {
        self.shouldRemovePostsBeforeGap = NO;

        [self.viewModel removePostsBeforeGap];
    }
}

#pragma mark - Table View Data Source Delegate

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKPostNode *node = [[STKPostNode alloc] init];

    [self tableView:tableView updateNode:node forObject:object atIndexPath:indexPath];

    return node;
}

- (void)tableView:(ASTableView *)tableView updateNode:(STKPostNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [node setupWithPost:object];
}

- (void)tableViewDidChangeContent:(ASTableView *)tableView {
    [self.listBackgroundView tableViewDidChangeContent];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STKPost *post = [self.viewModel objectAtIndexPath:indexPath];

    [STKAnalyticsManager logEventDidClickPostFromFeed:post];

    STKPostViewController *postViewController = [[STKPostViewController alloc] initWithPost:post];
    postViewController.transitioningDelegate = postViewController;

    [self presentViewController:postViewController animated:YES completion:nil];
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    __weak __typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Fetching additional posts...");

        [wself.viewModel fetchOlderPostsWithCompletion:^(STKViewModelFetchResult result) {
            NSLog(@"Received additional posts with result: %ld", result);

            [context completeBatchFetching:YES];
//TODO: Do more testing to stop false negatives 

//            if (result == STKViewModelFetchResultFailed ||
//                result == STKViewModelFetchResultSuccessNone) {
//                [context cancelBatchFetching];
//            }
//
//            [context completeBatchFetching:[context batchFetchingWasCancelled]];
        }];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect rect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    if (scrollView.contentOffset.y < CGRectGetMaxY(rect)) {
        if (self.contentButtonShown) {
            [self hideNewContentView];
        }

        if (self.shouldRemovePostsBeforeGap) {
            [self removePostsBeforeGap];
        }
    }
}

#pragma mark - Pull To Refresh Delegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [view startLoading];

    __weak __typeof(self) wself = self;
    [self.viewModel fetchNewPostsWithCompletion:^(STKViewModelFetchResult result) {
        [wself handleNewFetchCompletionWithResult:result];
    }];
}

#pragma mark - Source List View Controller Delegate

- (void)sourceListViewController:(STKSourceListViewController *)sourceListViewController didSelectSourceType:(STKSourceType)sourceType {
    self.shouldRemovePostsBeforeGap = NO;
    
    __weak __typeof(self) wself = self;
    [self.viewModel updatePostsForSourceType:sourceType completion:^(STKViewModelFetchResult result) {
        [wself handleNewFetchCompletionWithResult:result];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - List Background Default Content View Delegate

- (void)listBackgroundDefaultContentView:(STKListBackgroundDefaultContentView *)contentView didTapActionButtonWithState:(STKListBackgroundViewState)state {
    if (state == STKListBackgroundViewStateError) {
        [self.viewModel fetchNewPostsWithCompletion:nil];
    }
}

@end
