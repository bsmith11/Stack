//
//  NSNumber+STKCGFloat.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "NSNumber+STKCGFloat.h"

@implementation NSNumber (STKCGFloat)

- (CGFloat)CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return self.doubleValue;
#else
    return self.floatValue;
#endif
}

@end
