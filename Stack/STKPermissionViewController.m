//
//  STKPermissionViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPermissionViewController.h"

#import "STKNotificationsManager.h"
#import "STKAnalyticsManager.h"

#import "UIColor+STKStyle.h"
#import "STKAttributes.h"

@interface STKPermissionViewController ()

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UILabel *acceptedLabel;
@property (strong, nonatomic) UILabel *deniedLabel;

@end

@implementation STKPermissionViewController

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] init];

    [self setupContainerView];
    [self setupImageView];
    [self setupTitleLabel];
    [self setupMessageLabel];
    [self setupActionButton];
    [self setupAcceptedLabel];
    [self setupDeniedLabel];
}

#pragma mark - Setup

- (void)setupContainerView {
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];

    [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:(2 * 25.0f)].active = YES;
    [self.view.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:(2 * 25.0f)].active = YES;
    [self.containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.imageView];

    UIImage *image = [UIImage imageNamed:@"Notification Large"];
    self.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.tintColor = [UIColor stk_stackColor];

    [self.imageView.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor].active = YES;
    [self.imageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor].active = YES;
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.titleLabel];

    self.titleLabel.numberOfLines = 0;

    NSString *title = @"Push Notifications";
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_onboardingTitleAttributes]];
    self.titleLabel.attributedText = attributedTitle;

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:(2 * 25.0f)].active = YES;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
}

- (void)setupMessageLabel {
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.messageLabel];

    self.messageLabel.numberOfLines = 0;

    NSString *message = @"We send you notifications when new articles are posted from your favorite news sources";
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message attributes:[STKAttributes stk_onboardingMessageAttributes]];
    self.messageLabel.attributedText = attributedMessage;

    [self.messageLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:25.0f].active = YES;
    [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
}

- (void)setupActionButton {
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.actionButton];

    [self.actionButton addTarget:self action:@selector(didTapActionButton) forControlEvents:UIControlEventTouchUpInside];

    NSString *actionTitle = @"Enable";
    NSAttributedString *attributedActionTitle = [[NSAttributedString alloc] initWithString:actionTitle attributes:[STKAttributes stk_onboardingActionAttributes]];
    [self.actionButton setAttributedTitle:attributedActionTitle forState:UIControlStateNormal];
    CGFloat inset = 12.5f;
    self.actionButton.contentEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset);

    [self.actionButton.topAnchor constraintEqualToAnchor:self.messageLabel.bottomAnchor constant:25.0f].active = YES;
    [self.actionButton.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;
    [self.actionButton.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor].active = YES;
}

- (void)setupAcceptedLabel {
    self.acceptedLabel = [[UILabel alloc] init];
    self.acceptedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.acceptedLabel];

    NSString *acceptedTitle = @"Enabled";
    NSMutableDictionary *attributes = [[STKAttributes stk_onboardingActionAttributes] mutableCopy];
    attributes[NSForegroundColorAttributeName] = [UIColor stk_tealColor];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:acceptedTitle attributes:attributes];
    self.acceptedLabel.attributedText = attributedTitle;

    [self.acceptedLabel.topAnchor constraintEqualToAnchor:self.messageLabel.bottomAnchor constant:25.0f].active = YES;
    [self.acceptedLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [self.acceptedLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
    [self.acceptedLabel.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;

    self.acceptedLabel.alpha = 0.0f;
}

- (void)setupDeniedLabel {
    self.deniedLabel = [[UILabel alloc] init];
    self.deniedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.deniedLabel];

    NSString *deniedTitle = @"Denied";
    NSMutableDictionary *attributes = [[STKAttributes stk_onboardingActionAttributes] mutableCopy];
    attributes[NSForegroundColorAttributeName] = [UIColor stk_mluColor];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:deniedTitle attributes:attributes];
    self.deniedLabel.attributedText = attributedTitle;

    [self.deniedLabel.topAnchor constraintEqualToAnchor:self.messageLabel.bottomAnchor constant:25.0f].active = YES;
    [self.deniedLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor].active = YES;
    [self.deniedLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
    [self.deniedLabel.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor].active = YES;

    self.deniedLabel.alpha = 0.0f;
}

#pragma mark - Actions

- (void)didTapActionButton {
    [STKAnalyticsManager logEventDidAcceptNotificationsPrettyPlease];

    self.actionButton.userInteractionEnabled = NO;

    [UIView animateWithDuration:0.3 animations:^{
        self.actionButton.alpha = 0.0f;
    }];

    [[STKNotificationsManager sharedInstance] requestNotificationsPermissionWithCompletion:^(BOOL granted) {
        [STKAnalyticsManager logEventDidEnableNotificationsPermission:granted];

        if (granted) {
            [UIView animateWithDuration:0.3 animations:^{
                self.acceptedLabel.alpha = 1.0f;
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(permissionViewControllerDidFinish:)]) {
                    [self.delegate permissionViewControllerDidFinish:self];
                }
            }];
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                self.deniedLabel.alpha = 1.0f;
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(permissionViewControllerDidFinish:)]) {
                    [self.delegate permissionViewControllerDidFinish:self];
                }
            }];
        }
    }];
}

@end
