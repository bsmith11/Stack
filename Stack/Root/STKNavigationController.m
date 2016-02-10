//
//  STKNavigationController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKNavigationController.h"
#import "STKSourceListViewController.h"
#import "STKModalAnimationController.h"

@interface STKNavigationController () <UINavigationControllerDelegate>

@end

@implementation STKNavigationController

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
}

#pragma mark - Navigation Controller Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if ([fromVC isKindOfClass:[STKSourceListViewController class]] || [toVC isKindOfClass:[STKSourceListViewController class]]) {
        STKModalAnimationController *animationController;

        if (operation == UINavigationControllerOperationPush) {
            animationController = [STKModalAnimationController positiveAnimationController];
        }
        else {
            animationController = [STKModalAnimationController negativeAnimationController];
        }

        return animationController;
    }
    else {
        return nil;
    }
}

@end
