//
//  STKInteractiveViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKInteractiveViewController.h"

#import "STKSlideAnimationController.h"

#import <tgmath.h>

@interface STKInteractiveViewController ()

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@property (strong, nonatomic) UIPanGestureRecognizer *backPanGestureRecognizer;

@end

@implementation STKInteractiveViewController

- (BOOL)prefersStatusBarHidden {
    return self.presentingViewController.prefersStatusBarHidden;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackNavigationPan:)];
    [self.view addGestureRecognizer:self.backPanGestureRecognizer];
}

#pragma mark - Actions

- (void)handleBackNavigationPan:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];

            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
            break;

        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [gesture translationInView:gesture.view];

            if (translation.x > 0) {
                CGFloat percent = __tg_fabs(translation.x / CGRectGetWidth(gesture.view.bounds));

                [self.interactionController updateInteractiveTransition:percent];
            }
            else {
                [self.interactionController updateInteractiveTransition:0.0f];
            }
        }
            break;

        case UIGestureRecognizerStateEnded: {
            if ([gesture velocityInView:gesture.view].x > 0) {
                [self.interactionController finishInteractiveTransition];
            }
            else {
                [self.interactionController cancelInteractiveTransition];
            }

            self.interactionController = nil;
        }
            break;

        default:
            break;
    }
}

#pragma mark - View Controller Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    STKSlideAnimationController *animationController = [STKSlideAnimationController positiveAnimationController];

    if (self.interactionController) {
        animationController.interactive = YES;
    }

    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    STKSlideAnimationController *animationController = [STKSlideAnimationController negativeAnimationController];

    if (self.interactionController) {
        animationController.interactive = YES;
    }

    return animationController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactionController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactionController;
}

@end
