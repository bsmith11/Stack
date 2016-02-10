//
//  STKAppearance.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAppearance.h"

#import "STKAttributes.h"
#import "UIColor+STKStyle.h"

@implementation STKAppearance

+ (void)load {
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = [STKAttributes stk_navigationBarTitleAttributes];
    [UINavigationBar appearance].barTintColor = [UIColor stk_stackColor];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    [UITabBar appearance].translucent = NO;
    [UITabBar appearance].shadowImage = [[UIImage alloc] init];
    [UITabBar appearance].backgroundImage = [[UIImage alloc] init];
    [UITabBar appearance].tintColor = [UIColor stk_stackColor];

    [UIPageControl appearance].pageIndicatorTintColor = [UIColor lightGrayColor];
    [UIPageControl appearance].currentPageIndicatorTintColor = [UIColor stk_stackColor];

    [UIToolbar appearance].tintColor = [UIColor whiteColor];
    [UIToolbar appearance].barTintColor = [UIColor stk_stackColor];
    [UIToolbar appearance].translucent = NO;
    [[UIToolbar appearance] setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny];
    [[UIToolbar appearance] setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    [UISearchBar appearance].tintColor = [UIColor whiteColor];
    [UISearchBar appearance].barTintColor = [UIColor stk_stackColor];
    [UISearchBar appearance].translucent = NO;
    [UISearchBar appearance].backgroundImage = [[UIImage alloc] init];

    [UISegmentedControl appearance].tintColor = [UIColor whiteColor];

    [UITextField appearance].tintColor = [UIColor stk_stackColor];
}

@end
