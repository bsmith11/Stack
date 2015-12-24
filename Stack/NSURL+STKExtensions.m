//
//  NSURL+STKExtensions.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "NSURL+STKExtensions.h"

@implementation NSURL (STKExtensions)

- (BOOL)stk_isMailLink {
    BOOL result;
    NSString *mailPrefix = @"mailto:";

    if (self.absoluteString.length < mailPrefix.length) {
        result = NO;
    }
    else {
        NSString *prefix = [self.absoluteString substringToIndex:mailPrefix.length];
        result = [prefix isEqualToString:mailPrefix];
    }

    return result;
}

- (NSString *)stk_emailAddress {
    NSString *emailAddress;

    if ([self stk_isMailLink]) {
        NSString *mailPrefix = @"mailto:";
        NSRange range = [self.absoluteString rangeOfString:mailPrefix];
        emailAddress = [self.absoluteString stringByReplacingCharactersInRange:range withString:@""];
    }
    else {
        emailAddress = nil;
    }

    return emailAddress;
}

@end
