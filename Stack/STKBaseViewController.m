//
//  STKBaseViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBaseViewController.h"

@interface STKBaseViewController ()

@end

@implementation STKBaseViewController

#pragma mark - Lifecycle

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setHidesBackButton:YES animated:NO];

    [self setupBackBarButtonItem];
}

#pragma mark - Setup

- (void)setupBackBarButtonItem {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:nil
                                                                         action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

#pragma mark - Getters

- (STKNavigationController *)stk_navigationController {
    STKNavigationController *navigationController = nil;

    if ([self.navigationController isKindOfClass:[STKNavigationController class]]) {
        navigationController = (STKNavigationController *)self.navigationController;
    }

    return navigationController;
}

@end
