//
//  UIColor+STKStyle.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIColor+STKStyle.h"

#import <RZUtils/UIColor+RZExtensions.h>

@implementation UIColor (STKStyle)

+ (UIColor *)stk_shadowColor {
    return [[UIColor stk_stackColor] colorWithAlphaComponent:0.5f];
}

+ (UIColor *)stk_twitterColor {
    return [UIColor rz_colorFromHexString:@"0084B4"];
}

+ (UIColor *)stk_backgroundColor {
//    return [UIColor rz_colorFromHexString:@"D3D6DB"];
    return [UIColor rz_colorFromHexString:@"D0D4DA"];
}

+ (UIColor *)stk_searchTextFieldColor {
    return [self whiteColor];
}

+ (UIColor *)stk_tealColor {
    return [UIColor rz_colorFromHexString:@"28C097"];
}


+ (UIColor *)stk_stackColor {
    return [UIColor rz_colorFromHexString:@"2E4046"];
}

+ (UIColor *)stk_skydColor {
    return [UIColor rz_colorFromHexString:@"637BFA"];
}

+ (UIColor *)stk_ultiworldColor {
    return [UIColor rz_colorFromHexString:@"008292"];
}

+ (UIColor *)stk_audlColor {
    return [UIColor rz_colorFromHexString:@"011A31"];
}

+ (UIColor *)stk_mluColor {
    return [UIColor rz_colorFromHexString:@"BF2D29"];
}

+ (UIColor *)stk_bamasecsColor {
    return [UIColor rz_colorFromHexString:@"1DADE9"];
}

+ (UIColor *)stk_sludgeColor {
    return [UIColor rz_colorFromHexString:@"543805"];
}

@end
