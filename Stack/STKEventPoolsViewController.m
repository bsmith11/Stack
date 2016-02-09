//
//  STKEventPoolsViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPoolsViewController.h"
#import "STKEventPoolDetailViewController.h"

#import "STKEventPoolsViewModel.h"

#import "STKEvent.h"
#import "STKEventGroup.h"
#import "STKEventStanding.h"

#import "STKEventPoolCell.h"
#import "STKEventPoolHeader.h"

#import "UITableViewCell+STKReuse.h"
#import "UITableViewHeaderFooterView+STKReuse.h"
#import "UIColor+STKStyle.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventPoolsViewController () <UITableViewDelegate, RZCollectionListTableViewDataSourceDelegate, STKEventPoolHeaderDelegate>

@property (strong, nonatomic) STKEventPoolsViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation STKEventPoolsViewController

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventPoolsViewModel alloc] initWithEventGroup:group];
        self.title = group.event.name;
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

    [self.navigationItem setHidesBackButton:NO animated:YES];

    [self.viewModel setupDataSourceWithTableView:self.tableView delegate:self];
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];

    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 42.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;

    [self.tableView registerClass:[STKEventPoolCell class] forCellReuseIdentifier:[STKEventPoolCell stk_reuseIdentifier]];
    [self.tableView registerClass:[STKEventPoolHeader class] forHeaderFooterViewReuseIdentifier:[STKEventPoolHeader stk_reuseIdentifier]];

    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKEventPoolCell *cell = [tableView dequeueReusableCellWithIdentifier:[STKEventPoolCell stk_reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithStanding:object];

    return cell;
}

#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    STKEventPoolHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[STKEventPoolHeader stk_reuseIdentifier]];
    STKEventPool *pool = [self.viewModel poolForSection:section];

    [header setupWithPool:pool section:section];
    header.delegate = self;

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [STKEventPoolHeader height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Event Pool Header Delegate

- (void)didSelectHeaderInSection:(NSInteger)section {
    STKEventPool *pool = [self.viewModel poolForSection:section];
    STKEventPoolDetailViewController *poolDetailViewController = [[STKEventPoolDetailViewController alloc] initWithEventPool:pool];

    [self.parentViewController.navigationController pushViewController:poolDetailViewController animated:YES];
}

@end
