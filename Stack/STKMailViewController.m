//
//  STKMailViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKMailViewController.h"

@interface STKMailViewController ()

@end

@implementation STKMailViewController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.presentingViewController.preferredStatusBarUpdateAnimation;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return nil;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
}

@end
