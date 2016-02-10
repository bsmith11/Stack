//
//  STKImageAnimationController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKImageAnimationController.h"

#import "STKImageCache.h"
#import "STKImageDownloader.h"

#import <pop/POP.h>
#import <AsyncDisplayKit/ASNetworkImageNode.h>

@implementation STKImageAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *container = [transitionContext containerView];

    if (!fromView) {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromView = fromViewController.view;
    }

    if (!toView) {
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toView = toViewController.view;
    }

    UIView *animatingView;
    CGPoint scale;
    ASNetworkImageNode *imageNode;

    if (self.imageURL) {
        imageNode = [[ASNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
        imageNode.displaysAsynchronously = NO;
        imageNode.URL = self.imageURL;
        imageNode.frame = self.originalRect;

        [container addSubview:imageNode.view];
    }

    if (self.positive) {
        toView.frame = fromView.frame;

        [container insertSubview:toView aboveSubview:fromView];

        animatingView = fromView;
        scale = CGPointMake(0.95f, 0.95f);
    }
    else {
        [container insertSubview:toView belowSubview:fromView];

        animatingView = toView;
        animatingView.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
        scale = CGPointMake(1.0f, 1.0f);
    }

    void (^completion)(POPAnimation *animation, BOOL finished) = ^(POPAnimation *animation, BOOL finished) {
        animatingView.transform = CGAffineTransformIdentity;
        [imageNode.view removeFromSuperview];

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    };

    void (^animations)() = ^{
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.toValue = [NSValue valueWithCGPoint:scale];

        if (imageNode) {
            CGRect frame = imageNode.frame;
            frame.origin.y = container.center.y - (CGRectGetHeight(frame) / 2);

            POPSpringAnimation *translationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            translationAnimation.toValue = [NSValue valueWithCGRect:frame];
            translationAnimation.completionBlock = completion;
            [imageNode pop_addAnimation:translationAnimation forKey:@"translation"];
        }
        else {
            scaleAnimation.completionBlock = completion;
        }

        [animatingView pop_addAnimation:scaleAnimation forKey:@"scale"];
    };

    animations();

//    [UIView animateWithDuration:[self transitionDuration:transitionContext]
//                     animations:animations
//                     completion:completion];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

@end
