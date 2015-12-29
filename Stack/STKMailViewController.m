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
    return self.presentingViewController.prefersStatusBarHidden;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return nil;
}

@end
