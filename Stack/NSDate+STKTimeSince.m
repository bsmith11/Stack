//
//  NSDate+STKTimeSince.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import CoreGraphics;

#import "NSDate+STKTimeSince.h"

@implementation NSDate (STKTimeSince)

- (NSString *)stk_timeSinceNow {
    NSTimeInterval timeSinceNow = -[self timeIntervalSinceNow];
    NSString *timeSinceNowString = nil;

    if (timeSinceNow > 0 && timeSinceNow < 60) {
        timeSinceNowString = @"Just now";
    }
    else if (timeSinceNow > 59 && timeSinceNow < 3600) {
        NSInteger value = (NSInteger)ceil(timeSinceNow / 60);
        NSString *pluralString = (value == 1) ? @"" : @"s";
        timeSinceNowString = [NSString stringWithFormat:@"%ld minute%@ ago", (long)value, pluralString];
    }
    else if (timeSinceNow > 3599 && timeSinceNow < 86400) {
        NSInteger value = (NSInteger)ceil(timeSinceNow / 3600);
        NSString *pluralString = (value == 1) ? @"" : @"s";
        timeSinceNowString = [NSString stringWithFormat:@"%ld hour%@ ago", (long)value, pluralString];
    }
    else if (timeSinceNow > 86399 && timeSinceNow < 172800) {
        timeSinceNowString = @"Yesterday";
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;

        timeSinceNowString = [dateFormatter stringFromDate:self];
    }

    return timeSinceNowString;
}

@end
