//
//  ASDisplayNode+STKShadow.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "ASDisplayNode+STKShadow.h"

#import "UIColor+STKStyle.h"

@implementation ASDisplayNode (STKShadow)

- (void)stk_setupShadow {
    self.shadowColor = [UIColor stk_shadowColor].CGColor;
    self.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.shadowOpacity = 1.0f;
    self.shadowRadius = 0.5f;
}

@end
