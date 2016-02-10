//
//  UIView+STKShadow.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIView+STKShadow.h"

#import "UIColor+STKStyle.h"

@implementation UIView (STKShadow)

- (void)stk_setupShadow {
    self.layer.shadowColor = [UIColor stk_shadowColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 0.5f;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
}

@end
