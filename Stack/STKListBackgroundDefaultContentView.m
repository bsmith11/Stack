//
//  STKListBackgroundDefaultContentView.m
//  Stack
//
//  Created by Bradley Smith on 12/25/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKListBackgroundDefaultContentView.h"

#import "UIColor+STKStyle.h"
#import "STKAttributes.h"

@interface STKListBackgroundDefaultContentView ()

@property (strong, nonatomic) NSMutableDictionary *images;
@property (strong, nonatomic) NSMutableDictionary *titles;
@property (strong, nonatomic) NSMutableDictionary *messages;
@property (strong, nonatomic) NSMutableDictionary *actionTitles;

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *actionButton;

@property (assign, nonatomic) STKListBackgroundViewState state;

@end

@implementation STKListBackgroundDefaultContentView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.images = [NSMutableDictionary dictionary];
        self.titles = [NSMutableDictionary dictionary];
        self.messages = [NSMutableDictionary dictionary];
        self.actionTitles = [NSMutableDictionary dictionary];

        [self setupContainerView];
        [self setupImageView];
        [self setupTitleLabel];
        [self setupMessageLabel];
        [self setupActionButton];
    }

    return self;
}

#pragma mark - Setup

- (void)setupContainerView {
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.containerView];

    [self.containerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.containerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:25.0f].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:25.0f].active = YES;
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.imageView];

    self.imageView.contentMode = UIViewContentModeCenter;

    [self.imageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor].active = YES;
    [self.imageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor].active = YES;
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.titleLabel];

    self.titleLabel.numberOfLines = 0;

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:50.0f].active = YES;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor].active = YES;
}

- (void)setupMessageLabel {
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.messageLabel];

    self.messageLabel.numberOfLines = 0;

    [self.messageLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12.5f].active = YES;
    [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.messageLabel.trailingAnchor].active = YES;
}

- (void)setupActionButton {
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.actionButton];

    [self.actionButton addTarget:self action:@selector(didTapActionButton) forControlEvents:UIControlEventTouchUpInside];

    [self.actionButton.heightAnchor constraintEqualToConstant:44.0f].active = YES;
    [self.actionButton.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor].active = YES;
    [self.actionButton.topAnchor constraintEqualToAnchor:self.messageLabel.bottomAnchor constant:25.0f].active = YES;
    [self.containerView.bottomAnchor constraintEqualToAnchor:self.actionButton.bottomAnchor].active = YES;
}

#pragma mark - Actions

- (void)didTapActionButton {
    if ([self.delegate respondsToSelector:@selector(listBackgroundDefaultContentView:didTapActionButtonWithState:)]) {
        [self.delegate listBackgroundDefaultContentView:self didTapActionButtonWithState:self.state];
    }
}

#pragma mark - State Attributes

- (UIImage *)imageForState:(STKListBackgroundViewState)state {
    return self.images[@(state)];
}

- (NSString *)titleForState:(STKListBackgroundViewState)state {
    return self.titles[@(state)];
}

- (NSString *)messageForState:(STKListBackgroundViewState)state {
    return self.messages[@(state)];
}

- (NSString *)actionTitleForState:(STKListBackgroundViewState)state {
    return self.actionTitles[@(state)];
}

- (void)setImage:(UIImage *)image forState:(STKListBackgroundViewState)state {
    if (image) {
        self.images[@(state)] = image;
    }
    else {
        [self.images removeObjectForKey:@(state)];
    }
}

- (void)setTitle:(NSString *)title forState:(STKListBackgroundViewState)state {
    if (title) {
        self.titles[@(state)] = title;
    }
    else {
        [self.titles removeObjectForKey:@(state)];
    }
}

- (void)setMessage:(NSString *)message forState:(STKListBackgroundViewState)state {
    if (message) {
        self.messages[@(state)] = message;
    }
    else {
        [self.messages removeObjectForKey:@(state)];
    }
}

- (void)setActionTitle:(NSString *)actionTitle forState:(STKListBackgroundViewState)state {
    if (actionTitle) {
        self.actionTitles[@(state)] = actionTitle;
    }
    else {
        [self.actionTitles removeObjectForKey:@(state)];
    }
}

#pragma mark - List Background View Content View Protocol

- (void)updateState:(STKListBackgroundViewState)state {
    self.state = state;

    self.imageView.image = self.images[@(state)];

    NSString *title = self.titles[@(state)] ?: @"";
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_emptyStateTitleAttributes]];
    self.titleLabel.attributedText = attributedTitle;

    NSString *message = self.messages[@(state)] ?: @"";
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message attributes:[STKAttributes stk_emptyStateMessageAttributes]];
    self.messageLabel.attributedText = attributedMessage;

    NSString *actionTitle = self.actionTitles[@(state)] ?: @"";
    NSAttributedString *attributedActionTitle = [[NSAttributedString alloc] initWithString:actionTitle attributes:[STKAttributes stk_emptyStateActionAttributes]];
    [self.actionButton setAttributedTitle:attributedActionTitle forState:UIControlStateNormal];
}

@end
