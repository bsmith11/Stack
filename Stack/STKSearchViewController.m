//
//  STKSearchViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/26/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSearchViewController.h"
#import "STKPostViewController.h"

#import "STKSearchViewModel.h"
#import "STKSourceListViewModel.h"

#import "STKPost.h"
#import "STKPostSearchResult.h"

#import "STKPostNode.h"
#import "STKSourceListNode.h"

#import "STKListBackgroundView.h"
#import "STKListBackgroundDefaultContentView.h"
#import "STKSearchField.h"
#import "STKTableViewDataSource.h"
#import "UIColor+STKStyle.h"
#import "UIBarButtonItem+STKExtensions.h"

#import <AsyncDisplayKit/ASTableView.h>
#import <RZUtils/UIViewController+RZKeyboardWatcher.h>
#import <RZDataBinding/RZDataBinding.h>
#import <KVOController/FBKVOController.h>
#import <RZUtils/RZCommonUtils.h>

@interface STKSearchViewController () <ASTableViewDelegate, STKTableViewDataSourceDelegate, STKListBackgroundDefaultContentViewDelegate>

@property (strong, nonatomic) STKSourceListViewModel *sourceListViewModel;
@property (strong, nonatomic) STKSearchViewModel *searchViewModel;

@property (strong, nonatomic) STKSearchField *searchField;
@property (strong, nonatomic) NSArray *cancelBarButtonItems;
@property (strong, nonatomic) ASTableView *sourceListTableView;
@property (strong, nonatomic) ASTableView *searchTableView;
@property (strong, nonatomic) STKListBackgroundView *listBackgroundView;

@end

@implementation STKSearchViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.searchViewModel = [[STKSearchViewModel alloc] init];
        self.sourceListViewModel = [[STKSourceListViewModel alloc] initWithSourceListType:STKSourceListTypeSearchAvailable];

        UIImage *image = [UIImage imageNamed:@"Search Off Icon"];
        UIImage *selectedImage = [UIImage imageNamed:@"Search On Icon"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:image selectedImage:selectedImage];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupBarButtonItems];
    [self setupSourceListTableView];
    [self setupSearchTableView];

    self.searchTableView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupObservers];
    [self setupKeyboardObserver];

    [self.sourceListViewModel setupDataSourceWithTableView:self.sourceListTableView delegate:self];
    [self.searchViewModel setupDataSourceWithTableView:self.searchTableView delegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        self.sourceListTableView.frame = self.view.bounds;
        self.searchTableView.frame = self.view.bounds;
        [self setupListBackgroundView];
    }
}

- (void)dealloc {
    [self rz_unwatchKeyboard];
}

#pragma mark - Setup

- (void)setupBarButtonItems {
    self.searchField = [[STKSearchField alloc] initWithFrame:CGRectZero];
    [self.searchField stk_setPlaceholderText:@"Find articles"];
    [self.searchField addTarget:self action:@selector(searchFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.searchField addTarget:self action:@selector(searchFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.searchField addTarget:self action:@selector(searchFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self.searchField sizeToFit];
    self.searchField.width = CGRectGetWidth(self.navigationController.navigationBar.frame) - (2 * 16.0f);
    
    UIBarButtonItem *searchFieldItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchField];
    self.navigationItem.leftBarButtonItem = searchFieldItem;

    CGFloat width = (12.5f - 16.0f);
    UIBarButtonItem *fixedSpaceBarButtonItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:width];
    UIImage *cancelImage = [[UIImage imageNamed:@"Cancel Off Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelBarButtonItem)];
    self.cancelBarButtonItems = @[fixedSpaceBarButtonItem, cancelBarButtonItem];
}

- (void)setupSourceListTableView {
    self.sourceListTableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
    self.sourceListTableView.backgroundColor = [UIColor stk_backgroundColor];
    self.sourceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.sourceListTableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.sourceListTableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.sourceListTableView.asyncDelegate = self;

    [self.view addSubview:self.sourceListTableView];
}

- (void)setupSearchTableView {
    self.searchTableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
    self.searchTableView.backgroundColor = [UIColor stk_backgroundColor];
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.searchTableView.contentInset = UIEdgeInsetsMake(topInset + 6.25f, 0.0f, bottomInset + 6.25f, 0.0f);
    self.searchTableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.searchTableView.asyncDelegate = self;

    [self.view addSubview:self.searchTableView];
}

- (void)setupListBackgroundView {
    self.listBackgroundView = [[STKListBackgroundView alloc] initWithTableView:self.searchTableView];

    STKListBackgroundDefaultContentView *contentView = [[STKListBackgroundDefaultContentView alloc] init];
    contentView.delegate = self;

    [contentView setImage:[UIImage imageNamed:@"Search Large"] forState:STKListBackgroundViewStateEmpty];
    [contentView setTitle:@"Search" forState:STKListBackgroundViewStateEmpty];
    [contentView setMessage:@"Find articles based on keywords" forState:STKListBackgroundViewStateEmpty];

    self.listBackgroundView.contentView = contentView;
}

- (void)setupObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;

    __weak __typeof(self) wself = self;

    [self.KVOController observe:self.searchViewModel keyPath:RZDB_KP_OBJ(self.searchViewModel, searching) options:options block:^(id observer, id object, NSDictionary *change) {
        NSNumber *searching = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

        wself.searchField.loading = searching.boolValue;
    }];

    [self.searchViewModel rz_bindKey:RZDB_KP_OBJ(self.searchViewModel, sourceType) toKeyPath:RZDB_KP_OBJ(self.sourceListViewModel, sourceType) ofObject:self.sourceListViewModel];
}

- (void)setupKeyboardObserver {
    __weak __typeof(self) wself = self;

    RZKeyboardAnimationBlock animations = ^(BOOL keyboardVisible, CGRect keyboardFrame) {
        UIEdgeInsets contentInset = wself.searchTableView.contentInset;
        UIEdgeInsets indicatorInset = wself.searchTableView.scrollIndicatorInsets;
        CGFloat bottomInset = keyboardVisible ? CGRectGetHeight(keyboardFrame) : CGRectGetHeight(wself.tabBarController.tabBar.frame);

        contentInset.bottom = bottomInset + 6.25f;
        indicatorInset.bottom = bottomInset;

        wself.searchTableView.contentInset = contentInset;
        wself.searchTableView.scrollIndicatorInsets = indicatorInset;
    };

    [self rz_watchKeyboardShowWithAnimations:animations animated:YES];
}

#pragma mark - Actions

- (void)searchFieldEditingDidBegin:(STKSearchField *)searchField {
    [self showCancelBarButtonItems];
}

- (void)searchFieldEditingChanged:(STKSearchField *)searchField {
    [self.searchViewModel searchPostsWithText:searchField.text];
}

- (void)searchFieldEditingDidEnd:(STKSearchField *)searchField {

}

- (void)didTapCancelBarButtonItem {
    [self.searchField stk_clearText];

    [self.searchField resignFirstResponder];
    [self hideCancelBarButtonItems];
}

- (void)showCancelBarButtonItems {
    if (!self.navigationItem.rightBarButtonItems) {
        UIBarButtonItem *cancelBarButtonItem = self.cancelBarButtonItems.lastObject;
        CGFloat offset = cancelBarButtonItem.image.size.width + 12.5f;

        [UIView animateWithDuration:0.25 animations:^{
            self.searchField.width = self.searchField.width - offset;
        }];

        [self.navigationItem setRightBarButtonItems:self.cancelBarButtonItems animated:YES];

        self.sourceListTableView.hidden = YES;
        self.searchTableView.hidden = NO;
    }
}

- (void)hideCancelBarButtonItems {
    UIBarButtonItem *cancelBarButtonItem = self.cancelBarButtonItems.lastObject;
    CGFloat offset = cancelBarButtonItem.image.size.width + 12.5f;

    [UIView animateWithDuration:0.25 animations:^{
        self.searchField.width = self.searchField.width + offset;
    }];

    [self.navigationItem setRightBarButtonItems:nil animated:YES];

    self.sourceListTableView.hidden = NO;
    self.searchTableView.hidden = YES;
}

#pragma mark - Table View Data Source Delegate

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node = nil;

    if ([tableView isEqual:self.sourceListTableView]) {
        node = [[STKSourceListNode alloc] init];
    }
    else if ([tableView isEqual:self.searchTableView]) {
        node = [[STKPostNode alloc] init];
    }

    [self tableView:tableView updateNode:node forObject:object atIndexPath:indexPath];

    return node;
}

- (void)tableView:(ASTableView *)tableView updateNode:(ASCellNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([node isKindOfClass:[STKSourceListNode class]]) {
        STKSourceListNode *sourceNode = (STKSourceListNode *)node;
        STKSourceType sourceType = [object integerValue];
        BOOL selected = (self.sourceListViewModel.sourceType == sourceType);

        [sourceNode setupWithSourceType:sourceType selected:selected];
    }
    else {
        STKPostNode *postNode = (STKPostNode *)node;
        [postNode setupWithPostSearchResult:object];
    }
}

- (void)tableViewDidChangeContent:(ASTableView *)tableView {
    if ([tableView isEqual:self.sourceListTableView]) {

    }
    else if ([tableView isEqual:self.searchTableView]) {
        [self.listBackgroundView tableViewDidChangeContent];
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.sourceListTableView]) {
        [self.sourceListViewModel didSelectRowAtIndexPath:indexPath];

        UIColor *color = [STKSource colorForType:self.sourceListViewModel.sourceType];
        [UIView animateWithDuration:0.25 animations:^{
            self.navigationController.navigationBar.barTintColor = color;
        }];
    }
    else if ([tableView isEqual:self.searchTableView]) {
        [self.searchField resignFirstResponder];

        STKPostSearchResult *result = [self.searchViewModel objectAtIndexPath:indexPath];
        STKPost *post = [STKPost postFromPostSearchResult:result];
        STKPostViewController *postViewController = [[STKPostViewController alloc] initWithPost:post];
        postViewController.transitioningDelegate = postViewController;

        [self presentViewController:postViewController animated:YES completion:nil];
    }
}

#pragma mark - List Background Default Content View Delegate

- (void)listBackgroundDefaultContentView:(STKListBackgroundDefaultContentView *)contentView didTapActionButtonWithState:(STKListBackgroundViewState)state {

}

@end
