//
//  STKListBackgroundView.m
//  Stack
//
//  Created by Bradley Smith on 12/23/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKListBackgroundView.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <KVOController/FBKVOController.h>
#import <RZDataBinding/RZDataBinding.h>
#import <RZUtils/RZCommonUtils.h>

@interface STKListBackgroundView ()

@property (strong, nonatomic) NSLayoutConstraint *contentViewTop;
@property (strong, nonatomic) NSLayoutConstraint *contentViewBottom;

@property (weak, nonatomic) ASTableView *tableView;
@property (weak, nonatomic) id <STKListBackgroundViewDelegate> delegate;

@end

@implementation STKListBackgroundView

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(ASTableView *)tableView delegate:(id<STKListBackgroundViewDelegate>)delegate {
    self = [super init];

    if (self) {
        [self setupWithTableView:tableView];
        [self setupObservers];
        self.delegate = delegate;

        self.state = STKListBackgroundViewStateEmpty;
    }

    return self;
}

#pragma mark - Setup

- (void)setupWithTableView:(ASTableView *)tableView {
    self.tableView = tableView;
    tableView.backgroundView = self;

    [self tableViewDidChangeContent];
}

- (void)addConstraintsForContentView:(UIView <STKListBackgroundContentViewProtocol> *)contentView {
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentView];

    self.contentViewTop = [contentView.topAnchor constraintEqualToAnchor:self.topAnchor];
    self.contentViewTop.active = YES;
    [contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor].active = YES;
    self.contentViewBottom = [self.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor];
    self.contentViewBottom.active = YES;

    [self updateContentViewConstraintsWithInsets:self.tableView.contentInset];
}

- (void)updateContentViewConstraintsWithInsets:(UIEdgeInsets)insets {
    self.contentViewTop.constant = insets.top;
    self.contentViewBottom.constant = insets.bottom;
}

- (void)setupObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;
    __weak __typeof(self) wself = self;

    [self.KVOController observe:self.tableView keyPath:RZDB_KP_OBJ(self.tableView, contentInset) options:options block:^(id observer, id object, NSDictionary *change) {
        NSValue *value = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

        if (value) {
            [wself updateContentViewConstraintsWithInsets:[value UIEdgeInsetsValue]];
        }
    }];
}

#pragma mark - Actions

- (void)tableViewDidChangeContent {
    [self updateRowCountForTableView:self.tableView];
}

- (void)updateRowCountForTableView:(ASTableView *)tableView {
    NSInteger sectionCount = tableView.numberOfSections;
    NSInteger rowCount = 0;

    for (NSInteger section = 0; section < sectionCount; section++) {
        rowCount += [tableView numberOfRowsInSection:section];
    }

    self.hidden = (rowCount > 0);
    tableView.scrollEnabled = (rowCount > 0);
}

#pragma mark - Setters

- (void)setState:(STKListBackgroundViewState)state {
    if (_state != state) {
        _state = state;

        [self.contentView updateState:state];
    }
}

- (void)setLoading:(BOOL)loading {
    if (_loading != loading) {
        _loading = loading;

        self.contentView.loading = loading;
    }
}

- (void)setContentView:(UIView<STKListBackgroundContentViewProtocol> *)contentView {
    if (![_contentView isEqual:contentView]) {
        [_contentView removeFromSuperview];

        _contentView = contentView;

        [self addConstraintsForContentView:contentView];
        [contentView updateState:self.state];
    }
}

@end
