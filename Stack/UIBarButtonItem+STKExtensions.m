//
//  UIBarButtonItem+STKExtensions.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIBarButtonItem+STKExtensions.h"

@implementation UIBarButtonItem (STKExtensions)

+ (UIBarButtonItem *)stk_fixedSpaceBarButtonItemWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    fixedSpaceBarButtonItem.width = width;

    return fixedSpaceBarButtonItem;
}

+ (UIBarButtonItem *)stk_flexibleSpaceBarButtonItem {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    return flexibleSpaceBarButtonItem;
}

@end
