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

@property (strong, nonatomic) UIView *imageContainerView;
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

    [self setupImageContainerView];
    [self setupTitleLabel];
    [self setupMessageLabel];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        //construct it at original size of vector asset
        CGFloat width = 1024.0f;
        CGFloat height = 1024.0f;
        CGFloat x = (CGRectGetWidth(self.view.bounds) - width) / 2;
        CGFloat y = (CGRectGetHeight(self.view.bounds) - height) / 2;

        CGFloat windowHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
        self.verticalOffset = (windowHeight - viewHeight) / 2;

        self.imageContainerView.frame = CGRectMake(x, y + self.verticalOffset, width, height);

        [self.titleLabel sizeToFit];

        x = (CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.titleLabel.bounds)) / 2;
        y = ((viewHeight - CGRectGetHeight(self.titleLabel.bounds)) / 2) + 12.5f;

        self.titleLabel.frame = CGRectMake(x, y, CGRectGetWidth(self.titleLabel.bounds), CGRectGetHeight(self.titleLabel.bounds));

        CGSize constrainedSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 100.0f, CGFLOAT_MAX);
        CGSize size = [self.messageLabel sizeThatFits:constrainedSize];
        x = (CGRectGetWidth(self.view.bounds) - size.width) / 2;
        y = CGRectGetMaxY(self.titleLabel.frame) + 12.5f;

        self.messageLabel.frame = CGRectMake(x, y, size.width, size.height);

        //scale it down to that it matches the size of the launch icon exactly
        CGFloat scaleX = 150.0f / width;
        CGFloat scaleY = 150.0f / height;
        self.imageContainerView.transform = CGAffineTransformMakeScale(scaleX, scaleY);

        int64_t delay = (int64_t)(0.5 * NSEC_PER_SEC);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self animateObjects];
        });
    }
}

#pragma mark - Setup

- (void)setupImageContainerView {
    self.imageContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.imageContainerView];

    //construct it at original size of vector asset
    CGFloat cornerRadius = 62.5f;
    UIColor *backgroundColor = [UIColor stk_stackColor];
    CGRect frame = CGRectMake(162.0f, 104.0f, 400.0f, 125.0f);
    NSArray *horizontalOffsets = @[@(0.0f),
                                   @(50.0f),
                                   @(100.0f),
                                   @(100.0f),
                                   @(50.0f)];
    NSArray *verticalOffsets = @[@(0.0f),
                                 @(47.0f),
                                 @(47.0f),
                                 @(47.0f),
                                 @(47.0f)];

    for (NSUInteger i = 0; i < 5; i++) {
        CAShapeLayer *item = [CAShapeLayer layer];
        frame.origin.x += [horizontalOffsets[i] doubleValue];
        if (i > 0) {
            frame.origin.y = CGRectGetMaxY(frame) + [verticalOffsets[i] doubleValue];
        }
        item.frame = frame;
        item.backgroundColor = backgroundColor.CGColor;
        item.cornerRadius = cornerRadius;

        [self.imageContainerView.layer addSublayer:item];
    }
}

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

    NSString *message = @"Read all of the biggest Ultimate news in one place";
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:[STKAttributes stk_onboardingMessageAttributes]];
    self.messageLabel.layer.opacity = 0.0f;
}

#pragma mark - Actions

- (void)animateObjects {
    NSArray *layers = self.imageContainerView.layer.sublayers;
    NSArray *labels = @[self.titleLabel, self.messageLabel];

    [layers pop_sequenceWithInterval:0.1
                          animations:^(CALayer *layer, NSInteger index) {
                              layer.pop_spring.opacity = 0.0f;
                              layer.pop_spring.pop_translationY = -50.0f;
                          }
                          completion:^(BOOL finished) {
                              [labels pop_sequenceWithInterval:0.1
                                                    animations:^(UILabel *label, NSInteger index) {
                                                        label.layer.pop_spring.opacity = 1.0f;
                                                        label.layer.pop_spring.pop_translationY = -12.5f;
                                                    }
                                                    completion:nil];
                          }];
}

@end
