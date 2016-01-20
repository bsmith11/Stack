//
//  STKLaunchImageView.m
//  Stack
//
//  Created by Bradley Smith on 1/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKLaunchImageView.h"

#import "UIColor+STKStyle.h"

#import <pop/POP.h>
#import <POP+MCAnimate/POP+MCAnimate.h>

@interface STKLaunchImageView ()

@property (assign, nonatomic) BOOL didLayoutSubviews;

@end

@implementation STKLaunchImageView

#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        [self setupItemLayers];
    }
}

#pragma mark - Setup

- (void)setupItemLayers {
    CGFloat scaleX = CGRectGetWidth(self.bounds) / 1024.0f;
    CGFloat scaleY = CGRectGetHeight(self.bounds) / 1024.0f;

    CGFloat x = 162.0f * scaleX;
    CGFloat y = 104.0f * scaleY;
    CGFloat width = 400.0f * scaleX;
    CGFloat height = 125.0f * scaleY;

    CGFloat cornerRadius = 62.5f * scaleX;
    CGFloat horizontalOffset = 50.0f * scaleX;
    CGFloat verticalOffset = 47.0f * scaleY;
    UIColor *backgroundColor = [UIColor stk_stackColor];

    CGRect frame = CGRectMake(x, y, width, height);
    NSArray *horizontalOffsets = @[@(0.0f),
                                   @(horizontalOffset),
                                   @(horizontalOffset * 2),
                                   @(horizontalOffset * 2),
                                   @(horizontalOffset)];
    NSArray *verticalOffsets = @[@(0.0f),
                                 @(verticalOffset),
                                 @(verticalOffset),
                                 @(verticalOffset),
                                 @(verticalOffset)];

    for (NSUInteger i = 0; i < 5; i++) {
        CAShapeLayer *item = [CAShapeLayer layer];
        frame.origin.x += [horizontalOffsets[i] doubleValue];
        if (i > 0) {
            frame.origin.y = CGRectGetMaxY(frame) + [verticalOffsets[i] doubleValue];
        }
        item.frame = frame;
        item.backgroundColor = backgroundColor.CGColor;
        item.cornerRadius = cornerRadius;

        [self.layer addSublayer:item];
    }
}

#pragma mark - Actions

- (void)animateWithCompletion:(void (^)(BOOL finished))completion {
    NSArray *layers = self.layer.sublayers;
    CGFloat modifier = (1.0 / 4.0);

    [layers pop_sequenceWithInterval:0.1
                          animations:^(CALayer *layer, NSInteger index) {
                              layer.pop_spring.opacity = 0.0f;
                              layer.pop_spring.pop_translationY = -CGRectGetHeight(layer.bounds) * modifier;
                          }
                          completion:nil];

    int64_t delay = (int64_t)(0.6 * NSEC_PER_SEC);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (completion) {
            completion(YES);
        }
    });
}

@end
