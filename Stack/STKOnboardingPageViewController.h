//
//  STKOnboardingPageViewController.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKOnboardingPageViewController;

@protocol STKOnboardingPageViewControllerDelegate <NSObject>

- (void)onboardingPageViewControllerDidFinish:(STKOnboardingPageViewController *)onboardingPageViewController;

@end

@interface STKOnboardingPageViewController : UIPageViewController

+ (instancetype)onboardingPageViewController;

@property (weak, nonatomic) id <STKOnboardingPageViewControllerDelegate> onboardingDelegate;

@end
