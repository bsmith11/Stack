//
//  STKEventsViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventsViewController.h"
#import "STKEventGroupsListViewController.h"

#import "STKEventsViewModel.h"

#import "STKEvent.h"
#import "STKEventGroup.h"

#import "STKEventCell.h"
#import "STKEventHeader.h"

#import "UIColor+STKStyle.h"
#import "UIBarButtonItem+STKExtensions.h"
#import "UITableViewCell+STKReuse.h"
#import "UITableViewHeaderFooterView+STKReuse.h"

#import <SSPullToRefresh/SSPullToRefresh.h>
#import <KVOController/FBKVOController.h>
#import <RZUtils/RZCommonUtils.h>
#import <RZUtils/UIViewController+RZKeyboardWatcher.h>
#import <RZDataBinding/RZDataBinding.h>
#import <RZCollectionList/RZCollectionList.h>

@interface STKEventsViewController () <UITableViewDelegate, RZCollectionListTableViewDataSourceDelegate, SSPullToRefreshViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) STKEventsViewModel *viewModel;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation STKEventsViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventsViewModel alloc] init];
        UIImage *image = [UIImage imageNamed:@"Events Off Icon"];
        UIImage *selectedImage = [UIImage imageNamed:@"Events On Icon"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:image selectedImage:selectedImage];
        self.navigationItem.title = @"Events";
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor stk_backgroundColor];

    [self setupSearchBar];
    [self setupSpinner];
    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupObservers];
    [self setupKeyboardObserver];

    [self.viewModel setupDataSourceWithTableView:self.tableView delegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        [self setupRefreshView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (self.searchBar.showsCancelButton) {
            [self.searchBar becomeFirstResponder];
        }
    }];
}

- (void)dealloc {
    [self rz_unwatchKeyboard];
}

#pragma mark - Setup

- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.navigationItem.titleView = self.searchBar;

    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchBar.placeholder = @"Find events";
}

- (void)setupSpinner {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.spinner];

    self.spinner.hidesWhenStopped = YES;
    self.spinner.color = [UIColor stk_stackColor];

    [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];

    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.estimatedRowHeight = 60.5f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;

    [self.tableView registerClass:[STKEventCell class] forCellReuseIdentifier:[STKEventCell stk_reuseIdentifier]];
    [self.tableView registerClass:[STKEventHeader class] forHeaderFooterViewReuseIdentifier:[STKEventHeader stk_reuseIdentifier]];

    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
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
                wself.tableView.hidden = (wself.tableView.numberOfSections == 0);
            }
            else {
                [wself.spinner stopAnimating];
                wself.tableView.hidden = NO;

                if (wself.refreshView.state == SSPullToRefreshViewStateLoading) {
                    BOOL animated = wself.navigationController.topViewController == wself;
                    [wself.refreshView finishLoadingAnimated:animated completion:nil];
                }
            }
        });
    }];
}

- (void)setupKeyboardObserver {
    __weak __typeof(self) wself = self;

    RZKeyboardAnimationBlock animations = ^(BOOL keyboardVisible, CGRect keyboardFrame) {
        UIEdgeInsets contentInset = wself.tableView.contentInset;
        UIEdgeInsets indicatorInset = wself.tableView.scrollIndicatorInsets;
        CGFloat bottomInset = keyboardVisible ? CGRectGetHeight(keyboardFrame) : CGRectGetHeight(wself.tabBarController.tabBar.frame);

        contentInset.bottom = bottomInset;
        indicatorInset.bottom = bottomInset;

        wself.tableView.contentInset = contentInset;
        wself.tableView.scrollIndicatorInsets = indicatorInset;
    };

    [self rz_watchKeyboardShowWithAnimations:animations animated:YES];
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKEventCell *cell = [tableView dequeueReusableCellWithIdentifier:[STKEventCell stk_reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithEvent:object];

    return cell;
}

#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    STKEventHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[STKEventHeader stk_reuseIdentifier]];
    NSDate *date = [self.viewModel dateForSection:(NSUInteger)section];

    [header setupWithDate:date];

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [STKEventHeader height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];

    STKEvent *event = [self.viewModel objectAtIndexPath:indexPath];
    STKEventGroupsListViewController *groupsListViewController = [[STKEventGroupsListViewController alloc] initWithEvent:event];

    [self.navigationController pushViewController:groupsListViewController animated:YES];
}

#pragma mark - Pull To Refresh Delegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [view startLoading];

    [self.viewModel downloadEventsWithCompletion:nil];
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.viewModel searchForText:searchText];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];

    [self searchBar:searchBar textDidChange:searchBar.text];
}

@end
