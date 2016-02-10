//
//  STKBaseAnimationController.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface STKBaseAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)positiveAnimationController;
+ (instancetype)negativeAnimationController;

@property (assign, nonatomic, getter=isPositive) BOOL positive;

@end
