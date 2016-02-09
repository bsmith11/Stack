//
//  STKEventGroupsListViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGroupsListViewController.h"
#import "STKEventDetailViewController.h"

#import "STKEventGroupsListViewModel.h"

#import "STKEventGroup.h"
#import "STKEvent.h"

#import "STKEventGroupsListCell.h"

#import "UITableViewCell+STKReuse.h"
#import "UITableViewHeaderFooterView+STKReuse.h"
#import "UIColor+STKStyle.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventGroupsListViewController () <UITableViewDelegate, RZCollectionListTableViewDataSourceDelegate>

@property (strong, nonatomic) STKEventGroupsListViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation STKEventGroupsListViewController

#pragma mark - Lifecycle

- (instancetype)initWithEvent:(STKEvent *)event {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventGroupsListViewModel alloc] initWithEvent:event];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor stk_backgroundColor];

    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:NO animated:NO];

    [self.viewModel setupDataSourceWithTableView:self.tableView delegate:self];
}

#pragma mark - Setup

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
    self.tableView.estimatedRowHeight = 42.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;

    [self.tableView registerClass:[STKEventGroupsListCell class] forCellReuseIdentifier:[STKEventGroupsListCell stk_reuseIdentifier]];

    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKEventGroupsListCell *cell = [tableView dequeueReusableCellWithIdentifier:[STKEventGroupsListCell stk_reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithGroup:object];

    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STKEventGroup *group = [self.viewModel objectAtIndexPath:indexPath];
    STKEventDetailViewController *eventDetailViewController = [[STKEventDetailViewController alloc] initWithEventGroup:group];

    [self.navigationController pushViewController:eventDetailViewController animated:YES];
}

@end
