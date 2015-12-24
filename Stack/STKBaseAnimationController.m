//
//  STKBaseAnimationController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBaseAnimationController.h"

@implementation STKBaseAnimationController

+ (instancetype)positiveAnimationController {
    id animationController = [[[self class] alloc] init];
    ((STKBaseAnimationController *)animationController).positive = YES;

    return animationController;
}

+ (instancetype)negativeAnimationController {
    id animationController = [[[self class] alloc] init];
    ((STKBaseAnimationController *)animationController).positive = NO;

    return animationController;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:[transitionContext transitionWasCancelled]];
}

@end
