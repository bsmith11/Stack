//
//  STKWelcomeViewController.m
//  Stack
//
//  Created by Bradley Smith on 1/18/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKWelcomeViewController.h"

#import "STKAttributes.h"
#import "UIColor+STKStyle.h"

#import <pop/POP.h>
#import <POP+MCAnimate/POP+MCAnimate.h>

@interface STKWelcomeViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;

@property (assign, nonatomic) BOOL didLayoutSubviews;
@property (assign, nonatomic) CGFloat verticalOffset;

@end

@implementation STKWelcomeViewController

#pragma mark - Lifecycle

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTitleLabel];
    [self setupMessageLabel];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        CGFloat windowHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
        self.verticalOffset = (windowHeight - viewHeight) / 2;

        [self.titleLabel sizeToFit];
        CGSize constrainedMessageSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 100.0f, CGFLOAT_MAX);
        CGSize messageSize = [self.messageLabel sizeThatFits:constrainedMessageSize];
        CGFloat infoHeight = CGRectGetHeight(self.titleLabel.bounds) + 12.5f + CGRectGetHeight(self.messageLabel.bounds);

        CGFloat x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.titleLabel.bounds)) / 2;
        CGFloat y = ((viewHeight - infoHeight) / 2) + 12.5f;

        self.titleLabel.frame = CGRectMake(x, y, CGRectGetWidth(self.titleLabel.bounds), CGRectGetHeight(self.titleLabel.bounds));

        x = (CGRectGetWidth(self.view.bounds) - messageSize.width) / 2;
        y = CGRectGetMaxY(self.titleLabel.frame) + 12.5f;

        self.messageLabel.frame = CGRectMake(x, y, messageSize.width, messageSize.height);

        [self animateObjects];
    }
}

#pragma mark - Setup

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.titleLabel];

    NSString *title = @"Stack";
    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_welcomeTitleAttributes]];
    self.titleLabel.layer.opacity = 0.0f;
}

- (void)setupMessageLabel {
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.messageLabel];

    NSString *message = @"The biggest Ultimate news in one place";
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:[STKAttributes stk_onboardingMessageAttributes]];
    self.messageLabel.layer.opacity = 0.0f;
}

#pragma mark - Actions

- (void)animateObjects {
    NSArray *labels = @[self.titleLabel, self.messageLabel];

    [labels pop_sequenceWithInterval:0.1
                          animations:^(UILabel *label, NSInteger index) {
                              label.layer.pop_spring.opacity = 1.0f;
                              label.layer.pop_spring.pop_translationY = -12.5f;
                          }
                          completion:nil];
}

@end
