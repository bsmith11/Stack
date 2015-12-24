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
//#import "STKSearchViewController.h"

#import "STKFeedViewModel.h"
//#import "STKSearchViewModel.h"

#import "STKPost.h"

#import "STKPostNode.h"

#import "UIColor+STKStyle.h"
#import "UIBarButtonItem+STKExtensions.h"
//#import "STKSearchTextField.h"
#import "STKAnalyticsManager.h"
#import "STKTableViewDataSource.h"

#import <AsyncDisplayKit/ASTableView.h>
#import <KVOController/FBKVOController.h>
#import <RZDataBinding/RZDataBinding.h>
#import <RZUtils/RZCommonUtils.h>
#import <tgmath.h>
#import <SSPullToRefresh/SSPullToRefresh.h>

@interface STKFeedViewController () <ASTableViewDelegate, STKTableViewDataSourceDelegate, SSPullToRefreshViewDelegate, STKSourceListViewControllerDelegate>//, STKSearchViewControllerDelegate>

//@property (strong, nonatomic) STKSearchViewController *searchViewController;
//@property (strong, nonatomic) STKSearchViewModel *searchViewModel;
@property (strong, nonatomic) STKSourceListViewController *sourceListViewController;
@property (strong, nonatomic) STKFeedViewModel *viewModel;
@property (strong, nonatomic) ASTableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;

@property (assign, nonatomic) BOOL hasLayoutSubviews;

@end

@implementation STKFeedViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.viewModel = [[STKFeedViewModel alloc] init];
        self.tabBarItem = self.viewModel.tabBarItem;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupBarButtonItems];
    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupObservers];
//    [self setupSearchViewController];
    [self setupSourceListViewController];

    [self.viewModel setupDataSourceWithTableView:self.tableView delegate:self];
    [self.viewModel updatePostsForSourceType:-1];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!self.hasLayoutSubviews) {
        self.hasLayoutSubviews = YES;

        self.tableView.frame = self.view.frame;
        [self setupRefreshView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.transitionCoordinator animateAlongsideTransitionInView:self.stk_navigationController.view animation:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIColor *color = [STKSource colorForType:self.viewModel.sourceType] ?: [UIColor stk_stackColor];
        self.navigationController.navigationBar.barTintColor = color;
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

    //    [self addRightBarButtonItems:self.listBarButtonItems width:listImage.size.width + kSTKFullPadding];
    //
    //    [self addSearchTextFieldBarButtonItem];
    //
    //    [self.searchTextField un_setPlaceholderText:@"Find articles"];
}

- (void)setupTableView {
    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:YES];
    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topInset = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(topInset + 6.25f, 0.0f, bottomInset + 6.25f, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.asyncDelegate = self;

    [self.view addSubview:self.tableView];
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

            if (downloading.boolValue) {
                [wself.spinner startAnimating];
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

//    [self.KVOController observe:self.searchViewModel keyPath:RZDB_KP_OBJ(self.searchViewModel, downloading) options:options block:^(id observer, id object, NSDictionary *change) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSNumber *downloading = RZNSNullToNil(change[NSKeyValueChangeNewKey]);
//
//            wself.searchTextField.loading = downloading.boolValue;
//        });
//    }];

    [self rz_bindKey:RZDB_KP_SELF(title) toKeyPath:RZDB_KP_OBJ(self.viewModel, title) ofObject:self.viewModel];
}

//- (void)setupSearchViewController {
//    self.searchViewModel = [[STKSearchViewModel alloc] init];
//    self.searchViewController = [[STKSearchViewController alloc] initWithViewModel:self.searchViewModel];
//    self.searchViewController.delegate = self;
//}

- (void)setupSourceListViewController {
    self.sourceListViewController = [[STKSourceListViewController alloc] init];
    self.sourceListViewController.delegate = self;
}

#pragma mark - Actions

//- (void)presentSearchViewController {
//    [STKAnalyticsManager logEventDidClickPostSearch];
//
//    [self addChildViewController:self.searchViewController];
//    [self.view addSubview:self.searchViewController.view];
//    self.searchViewController.view.frame = self.view.frame;
//    [self.searchViewController didMoveToParentViewController:self];
//}
//
//- (void)dismissSearchViewController {
//    [self.searchViewController willMoveToParentViewController:nil];
//    [self.searchViewController.view removeFromSuperview];
//    [self.searchViewController removeFromParentViewController];
//}
//
//- (void)searchTextFieldEditingChanged:(STKSearchTextField *)searchTextField {
//    [self.searchViewModel searchPostsWithText:searchTextField.text];
//}
//
//- (void)searchTextFieldEditingDidBegin:(STKSearchTextField *)searchTextField {
//    [super searchTextFieldEditingDidBegin:searchTextField];
//
//    if (!self.searchViewModel.searching) {
//        self.searchViewModel.searching = YES;
//        [self presentSearchViewController];
//    }
//}
//
//- (void)searchTextFieldEditingDidEnd:(STKSearchTextField *)searchTextField {
//    [super searchTextFieldEditingDidEnd:searchTextField];
//}
//
//- (void)didTapCancelBarButtonItem {
//    [super didTapCancelBarButtonItem];
//
//    [self.searchViewModel cancelSearching];
//    self.searchViewModel.searching = NO;
//    [self dismissSearchViewController];
//}

- (void)didTapListBarButtonItem {
    [self.navigationController pushViewController:self.sourceListViewController animated:YES];
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

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STKPost *post = [self.viewModel objectAtIndexPath:indexPath];

    [STKAnalyticsManager logEventDidClickPostFromFeed:post];

    STKPostViewController *postViewController = [[STKPostViewController alloc] initWithPost:post];
    postViewController.transitioningDelegate = postViewController;

    [self presentViewController:postViewController animated:YES completion:nil];
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Fetching additional posts...");

        [self.viewModel fetchOlderPostsWithCompletion:^(STKViewModelFetchResult result) {
            NSLog(@"Received additional posts...");

            if (result == STKViewModelFetchResultFailed || STKViewModelFetchResultCancelled) {
                [context cancelBatchFetching];
            }

            [context completeBatchFetching:[context batchFetchingWasCancelled]];
        }];
    });
}

#pragma mark - Pull To Refresh Delegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [view startLoading];

    [self.viewModel fetchNewPostsWithCompletion:nil];
}

//#pragma mark - Search View Controller Delegate
//
//- (void)searchViewController:(STKSearchViewController *)searchViewController didSelectPost:(STKPost *)post {
//    [self.searchTextField resignFirstResponder];
//
//    [STKAnalyticsManager logEventDidClickPostFromSearch:post];
//
//    STKPostViewModel *viewModel = [[STKPostViewModel alloc] initWithPost:post];
//    STKPostViewController *postViewController = [[STKPostViewController alloc] initWithViewModel:viewModel];
//
//    [self.navigationController pushViewController:postViewController animated:YES];
//}

#pragma mark - Source List View Controller Delegate

- (void)sourceListViewController:(STKSourceListViewController *)sourceListViewController didSelectSourceType:(STKSourceType)sourceType {
    [self.viewModel updatePostsForSourceType:sourceType];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
