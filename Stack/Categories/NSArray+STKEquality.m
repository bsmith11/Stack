//
//  NSArray+STKEquality.m
//  Stack
//
//  Created by Bradley Smith on 2/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "NSArray+STKEquality.h"

@implementation NSArray (STKEquality)

- (BOOL)stk_contentsIsEqualToArray:(NSArray *)array {
    if (self.count != array.count) {
        return NO;
    }

    __block BOOL equal = YES;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:array[idx]]) {
            equal = NO;
            *stop = YES;
        }
    }];

    return equal;
}

@end
