//
//  STKSlideAnimationController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSlideAnimationController.h"

static NSTimeInterval const kSTKSlideAnimationDurationInteractive = 0.5;
static NSTimeInterval const kSTKSlideAnimationDurationNormal = 0.65;

static CGFloat const kSTKSlideAnimationSecondaryTranslationPercentage = 0.25f;

@implementation STKSlideAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.isInteractive ? kSTKSlideAnimationDurationInteractive : kSTKSlideAnimationDurationNormal;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *container = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    CGAffineTransform fromStartTransform;
    CGAffineTransform fromEndTransform;
    CGAffineTransform toStartTransform;
    CGAffineTransform toEndTransform;

    if (self.positive) {
        toView.frame = fromView.frame;

        [container insertSubview:toView aboveSubview:fromView];

        fromStartTransform = CGAffineTransformIdentity;
        fromEndTransform = CGAffineTransformMakeTranslation(-CGRectGetWidth(container.bounds) * kSTKSlideAnimationSecondaryTranslationPercentage, 0.0f);

        toStartTransform = CGAffineTransformMakeTranslation(CGRectGetWidth(container.bounds), 0.0f);
        toEndTransform = CGAffineTransformIdentity;
    }
    else {
        [container insertSubview:toView belowSubview:fromView];

        fromStartTransform = CGAffineTransformIdentity;
        fromEndTransform = CGAffineTransformMakeTranslation(CGRectGetWidth(container.bounds), 0.0f);

        toStartTransform = CGAffineTransformMakeTranslation(-CGRectGetWidth(container.bounds) * kSTKSlideAnimationSecondaryTranslationPercentage, 0.0f);
        toEndTransform = CGAffineTransformIdentity;
    }

    fromView.transform = fromStartTransform;
    toView.transform = toStartTransform;

    void (^animations)() = ^ {
        fromView.transform = fromEndTransform;
        toView.transform = toEndTransform;
    };

    void (^completion)(BOOL finished) = ^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    };

    if (self.isInteractive) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:animations
                         completion:completion];
    }
    else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
             usingSpringWithDamping:1.0f
              initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animations
                         completion:completion];
    }
}

@end
