//
//  STKEventCrossoversViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventCrossoversViewController.h"
#import "STKEventCrossoversViewModel.h"

#import "STKEventGroup.h"

#import "STKEventPoolDetailCell.h"
#import "STKEventPoolDetailHeader.h"

#import "UITableViewCell+STKReuse.h"
#import "UITableViewHeaderFooterView+STKReuse.h"
#import "UIColor+STKStyle.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventCrossoversViewController () <UITableViewDelegate, RZCollectionListTableViewDataSourceDelegate>

@property (strong, nonatomic) STKEventCrossoversViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation STKEventCrossoversViewController

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventCrossoversViewModel alloc] initWithEventGroup:group];
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
    self.tableView.estimatedRowHeight = 89.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;

    [self.tableView registerClass:[STKEventPoolDetailCell class] forCellReuseIdentifier:[STKEventPoolDetailCell stk_reuseIdentifier]];
    [self.tableView registerClass:[STKEventPoolDetailHeader class] forHeaderFooterViewReuseIdentifier:[STKEventPoolDetailHeader stk_reuseIdentifier]];

    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.view.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
}

#pragma mark - Collection List Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    STKEventPoolDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[STKEventPoolDetailCell stk_reuseIdentifier] forIndexPath:indexPath];

    [cell setupWithGame:object];

    return cell;
}

#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    STKEventPoolDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[STKEventPoolDetailHeader stk_reuseIdentifier]];
    NSDate *date = [self.viewModel dateForSection:section];

    [header setupWithDate:date];

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [STKEventPoolDetailHeader height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
