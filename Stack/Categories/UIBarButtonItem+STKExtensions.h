//
//  UIBarButtonItem+STKExtensions.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface UIBarButtonItem (STKExtensions)

+ (UIBarButtonItem *)stk_fixedSpaceBarButtonItemWithWidth:(CGFloat)width;
+ (UIBarButtonItem *)stk_flexibleSpaceBarButtonItem;

@end
