//
//  STKEventPoolDetailViewController.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPoolDetailViewController.h"
#import "STKEventPoolDetailViewModel.h"

#import "STKEventPool.h"

#import "STKEventPoolDetailHeader.h"
#import "STKEventPoolDetailCell.h"

#import "UITableViewCell+STKReuse.h"
#import "UITableViewHeaderFooterView+STKReuse.h"
#import "UIColor+STKStyle.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventPoolDetailViewController () <UITableViewDelegate, RZCollectionListTableViewDataSourceDelegate>

@property (strong, nonatomic) STKEventPoolDetailViewModel *viewModel;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation STKEventPoolDetailViewController

#pragma mark - Lifecycle

- (instancetype)initWithEventPool:(STKEventPool *)pool {
    self = [super init];

    if (self) {
        self.viewModel = [[STKEventPoolDetailViewModel alloc] initWithEventPool:pool];
        self.title = pool.name;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGPoint top = CGPointMake(0.0f, -self.tableView.contentInset.top);
    [self.tableView setContentOffset:top animated:NO];
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
    self.tableView.estimatedRowHeight = 200.0f;
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
