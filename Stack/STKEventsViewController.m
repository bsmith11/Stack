//
//  STKEventsViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventsViewController.h"
#import "STKEventDetailViewController.h"

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
@property (strong, nonatomic) UIBarButtonItem *filterBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITextField *pickerTextField;
@property (strong, nonatomic) UIPickerView *pickerView;

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
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor stk_backgroundColor];

    [self setupBarButtonItems];
    [self setupPickerView];
    [self setupSearchBar];
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

- (void)dealloc {
    [self rz_unwatchKeyboard];
}

#pragma mark - Setup

- (void)setupBarButtonItems {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.color = [UIColor whiteColor];
    self.spinner.hidesWhenStopped = YES;

    UIBarButtonItem *spinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    self.navigationItem.leftBarButtonItem = spinnerBarButtonItem;

    UIImage *filterImage = [UIImage imageNamed:@"Filter Icon"];
    self.filterBarButtonItem = [[UIBarButtonItem alloc] initWithImage:filterImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapFilterBarButtonItem)];

    UIImage *cancelImage = [UIImage imageNamed:@"Cancel Off Icon"];
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelBarButtonItem)];

    self.navigationItem.rightBarButtonItem = self.filterBarButtonItem;
}

- (void)setupPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerView.dataSource = self.viewModel;
    self.pickerView.delegate = self.viewModel;
    self.pickerView.backgroundColor = [UIColor stk_stackColor];

    NSIndexPath *typeIndexPath = [self.viewModel indexPathForSelectedType];
    NSIndexPath *divisionIndexPath = [self.viewModel indexPathForSelectedDivision];

    [self.pickerView selectRow:typeIndexPath.row inComponent:typeIndexPath.section animated:NO];
    [self.pickerView selectRow:divisionIndexPath.row inComponent:divisionIndexPath.section animated:NO];

    self.pickerTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerTextField];
    self.pickerTextField.hidden = YES;
    self.pickerTextField.inputView = self.pickerView;
}

- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchBar];

    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchBar.placeholder = @"Find events";

    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    [self.searchBar.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:topInset].active = YES;
    [self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.searchBar.trailingAnchor].active = YES;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];

    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;

    [self.tableView registerClass:[STKEventCell class] forCellReuseIdentifier:[STKEventCell stk_reuseIdentifier]];
    [self.tableView registerClass:[STKEventHeader class] forHeaderFooterViewReuseIdentifier:[STKEventHeader stk_reuseIdentifier]];

    [self.tableView.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor].active = YES;
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

    [self.navigationItem rz_bindKey:RZDB_KP_OBJ(self.navigationItem, title) toKeyPath:RZDB_KP_OBJ(self.viewModel, title) ofObject:self.viewModel];
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

#pragma mark - Actions

- (void)didTapFilterBarButtonItem {
    [self.navigationItem setRightBarButtonItem:self.cancelBarButtonItem animated:YES];
    [self.pickerTextField becomeFirstResponder];
}

- (void)didTapCancelBarButtonItem {
    [self.navigationItem setRightBarButtonItem:self.filterBarButtonItem animated:YES];
    [self.pickerTextField resignFirstResponder];
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
    id object = [self.viewModel sectionObjectForSection:(NSUInteger)section];

    [header setupWithDate:object];

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [STKEventHeader height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STKEvent *event = [self.viewModel objectAtIndexPath:indexPath];
    STKEventGroup *group = [event groupWithType:self.viewModel.type division:self.viewModel.division];

    if (group) {
        STKEventDetailViewController *eventDetailViewController = [[STKEventDetailViewController alloc] initWithEventGroup:group];
        [self.navigationController pushViewController:eventDetailViewController animated:YES];
    }
    else {
        NSLog(@"No group exists on event: %@ for type: %@ and division: %@", event, @(self.viewModel.type), @(self.viewModel.division));
    }
}

#pragma mark - Pull To Refresh Delegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [view startLoading];

    [self.viewModel downloadEventsWithCompletion:nil];
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.viewModel searchForText:searchText];

    CGPoint top = CGPointMake(0.0f, -self.tableView.contentInset.top);
    [self.tableView setContentOffset:top animated:NO];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.filterBarButtonItem.enabled = NO;
    [self didTapCancelBarButtonItem];

    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.filterBarButtonItem.enabled = YES;

    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";

    [self searchBar:searchBar textDidChange:searchBar.text];
}

@end
