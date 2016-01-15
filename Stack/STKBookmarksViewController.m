//
//  STKBookmarksViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBookmarksViewController.h"
#import "STKPostViewController.h"

#import "STKBookmarksViewModel.h"

#import "STKPostNode.h"

#import "STKListBackgroundView.h"
#import "STKListBackgroundDefaultContentView.h"
#import "STKCollectionListTableViewDataSource.h"
#import "UIColor+STKStyle.h"
#import "STKAnalyticsManager.h"

#import <AsyncDisplayKit/ASTableView.h>

@interface STKBookmarksViewController () <ASTableViewDelegate, STKCollectionListTableViewDelegate, STKListBackgroundDefaultContentViewDelegate>

@property (strong, nonatomic) STKBookmarksViewModel *viewModel;
@property (strong, nonatomic) ASTableView *tableView;
@property (strong, nonatomic) STKListBackgroundView *listBackgroundView;

@end

@implementation STKBookmarksViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.viewModel = [[STKBookmarksViewModel alloc] init];
        UIImage *image = [UIImage imageNamed:@"Bookmark Off Icon"];
        UIImage *selectedImage = [UIImage imageNamed:@"Bookmark On Icon"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Bookmarks" image:image selectedImage:selectedImage];
        self.title = self.tabBarItem.title;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.viewModel setupCollectionListDataSourceWithTableView:self.tableView delegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        self.tableView.frame = self.view.bounds;
        [self setupListBackgroundView];

        self.listBackgroundView.hidden = !self.viewModel.empty;
        self.tableView.scrollEnabled = !self.viewModel.empty;
    }
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topInset = self.statusBarHeight + self.navigationBarHeight;
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(topInset + 6.25f, 0.0f, bottomInset + 6.25f, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.asyncDelegate = self;

    [self.view addSubview:self.tableView];
}

- (void)setupListBackgroundView {
    self.listBackgroundView = [[STKListBackgroundView alloc] initWithTableView:self.tableView];

    STKListBackgroundDefaultContentView *contentView = [[STKListBackgroundDefaultContentView alloc] init];
    contentView.delegate = self;

    [contentView setImage:[UIImage imageNamed:@"Bookmark Large"] forState:STKListBackgroundViewStateEmpty];
    [contentView setTitle:@"No Bookmarks" forState:STKListBackgroundViewStateEmpty];
    [contentView setMessage:@"Bookmark posts to access them offline" forState:STKListBackgroundViewStateEmpty];

    self.listBackgroundView.contentView = contentView;
}

#pragma mark - Collection List Data Source Delegate

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKPostNode *node = [[STKPostNode alloc] init];
    STKPost *post = (STKPost *)object;

    [self tableView:tableView updateNode:node forObject:post atIndexPath:indexPath];

    return node;
}

- (void)tableView:(ASTableView *)tableView updateNode:(STKPostNode *)node forObject:(STKPost *)post atIndexPath:(NSIndexPath *)indexPath {
    [node setupWithPost:post];
}

- (void)tableView:(ASTableView *)tableView didFinishUpdatingCompleted:(BOOL)completed {
    [self.listBackgroundView tableViewDidChangeContent];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STKPost *post = [self.viewModel objectAtIndexPath:indexPath];

    [STKAnalyticsManager logEventDidClickPostFromBookmarks:post];

    STKPostViewController *postViewController = [[STKPostViewController alloc] initWithPost:post];
    postViewController.transitioningDelegate = postViewController;

    [self presentViewController:postViewController animated:YES completion:nil];
}

#pragma mark - List Background Default Content View Delegate

- (void)listBackgroundDefaultContentView:(STKListBackgroundDefaultContentView *)contentView didTapActionButtonWithState:(STKListBackgroundViewState)state {
    
}

@end
