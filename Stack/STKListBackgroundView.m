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

@end

@implementation STKListBackgroundView

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(ASTableView *)tableView {
    self = [super init];

    if (self) {
        self.baseInsets = UIEdgeInsetsZero;
        self.emptyThreshold = 0;

        [self setupWithTableView:tableView];
        [self setupObservers];

        self.state = STKListBackgroundViewStateEmpty;
    }

    return self;
}

#pragma mark - Setup

- (void)setupWithTableView:(ASTableView *)tableView {
    self.tableView = tableView;
    [tableView addSubview:self];
    [tableView sendSubviewToBack:self];

    self.frame = tableView.bounds;

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
    self.contentViewTop.constant = insets.top + self.baseInsets.top;
    self.contentViewBottom.constant = insets.bottom + self.baseInsets.bottom;
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

    self.hidden = (rowCount > self.emptyThreshold);
    tableView.scrollEnabled = (rowCount > self.emptyThreshold);
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

- (void)setBaseInsets:(UIEdgeInsets)baseInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_baseInsets, baseInsets)) {
        CGFloat oldTopInset = _baseInsets.top;
        CGFloat oldBottomInset = _baseInsets.bottom;

        _baseInsets = baseInsets;

        self.contentViewTop.constant = self.contentViewTop.constant - oldTopInset + baseInsets.top;
        self.contentViewBottom.constant = self.contentViewBottom.constant - oldBottomInset + baseInsets.bottom;
    }
}

- (void)setEmptyThreshold:(NSInteger)emptyThreshold {
    if (_emptyThreshold != emptyThreshold) {
        _emptyThreshold = emptyThreshold;
    }

    [self tableViewDidChangeContent];
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
