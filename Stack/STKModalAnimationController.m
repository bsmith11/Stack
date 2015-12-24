//
//  STKModalAnimationController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKModalAnimationController.h"

static NSTimeInterval const kSTKModalAnimationDuration = 0.75;

@implementation STKModalAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kSTKModalAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];

    UIView *animatingView = nil;
    CGAffineTransform transform;

    if (self.positive) {
        [container insertSubview:toViewController.view aboveSubview:fromViewController.view];

        toViewController.view.frame = fromViewController.view.frame;

        animatingView = toViewController.view;
        animatingView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(toViewController.view.frame));
        transform = CGAffineTransformIdentity;
    }
    else {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];

        animatingView = fromViewController.view;
        transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(toViewController.view.frame));
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         animatingView.transform = transform;
                     }
                     completion:^(BOOL finished) {
                         animatingView.transform = CGAffineTransformIdentity;

                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
