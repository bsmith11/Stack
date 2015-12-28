//
//  STKSourceListViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSourceListViewController.h"

#import "STKSourceListViewModel.h"

#import "STKSourceListNode.h"

#import "STKTableViewDataSource.h"

#import "UIBarButtonItem+STKExtensions.h"
#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/ASTableView.h>

@interface STKSourceListViewController () <ASTableViewDelegate, STKTableViewDataSourceDelegate>

@property (strong, nonatomic) STKSourceListViewModel *viewModel;
@property (strong, nonatomic) ASTableView *tableView;

@end

@implementation STKSourceListViewController

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.title = @"Sources";

        self.viewModel = [[STKSourceListViewModel alloc] init];
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

    [self.viewModel setupDataSourceWithTableView:self.tableView delegate:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.tableView.frame = self.view.frame;
}

#pragma mark - Setup

- (void)setupBarButtonItems {
    CGFloat rightWidth = (12.5f - 16.0f);
    UIBarButtonItem *rightFixedSpaceBarButtonItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:rightWidth];

    UIImage *cancelImage = [UIImage imageNamed:@"Cancel Off Icon"];
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:cancelImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapCancelBarButtonItem)];

    [self.navigationItem setRightBarButtonItems:@[rightFixedSpaceBarButtonItem, cancelBarButtonItem] animated:YES];
}

- (void)setupTableView {
    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat topInset = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat bottomInset = CGRectGetHeight(self.tabBarController.tabBar.frame);
    self.tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
    self.tableView.asyncDelegate = self;

    [self.view addSubview:self.tableView];
}

#pragma mark - Actions

- (void)didTapCancelBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Data Source Delegate

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKSourceListNode *node = [[STKSourceListNode alloc] init];

    [self tableView:tableView updateNode:node forObject:object atIndexPath:indexPath];

    return node;
}

- (void)tableView:(ASTableView *)tableView updateNode:(STKSourceListNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKSourceType sourceType = [object integerValue];
    BOOL selected = (self.viewModel.sourceType == sourceType);

    [node setupWithSourceType:sourceType selected:selected];
}

- (void)tableViewDidChangeContent:(ASTableView *)tableView {
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel didSelectRowAtIndexPath:indexPath];

    if ([self.delegate respondsToSelector:@selector(sourceListViewController:didSelectSourceType:)]) {
        [self.delegate sourceListViewController:self didSelectSourceType:self.viewModel.sourceType];
    }
}

@end
