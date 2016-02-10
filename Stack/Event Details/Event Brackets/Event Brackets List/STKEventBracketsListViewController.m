//
//  STKEventBracketsListViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracketsListViewController.h"
#import "STKEventBracketsViewController.h"

#import "STKEventBracketsListViewModel.h"

#import "STKEventGroup.h"
#import "STKEventBracket.h"

#import "STKEventBracketsListCell.h"

#import "UITableViewCell+STKReuse.h"
#import "UITableViewHeaderFooterView+STKReuse.h"
#import "UIColor+STKStyle.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventBracketsListViewController () <UITableViewDelegate, RZCollectionListTableViewDataSourceDelegate>

@property (strong, nonatomic) STKEventBracketsListViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation STKEventBracketsListViewController

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventBracketsListViewModel alloc] initWithEventGroup:group];
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

    [self.tableView registerClass:[STKEventBracketsListCell class] forCellReuseIdentifier:[STKEventBracketsListCell stk_reuseIdentifier]];

    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKEventBracketsListCell *cell = [tableView dequeueReusableCellWithIdentifier:[STKEventBracketsListCell stk_reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithBracket:object];

    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    STKEventBracket *bracket = [self.viewModel objectAtIndexPath:indexPath];
    STKEventBracketsViewController *bracketsViewController = [[STKEventBracketsViewController alloc] initWithEventBracket:bracket];
    
    [self.parentViewController.navigationController pushViewController:bracketsViewController animated:YES];
}

@end
