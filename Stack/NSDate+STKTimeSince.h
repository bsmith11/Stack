//
//  NSDate+STKTimeSince.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@interface NSDate (STKTimeSince)

- (NSString *)stk_timeSinceNow;

+ (NSDate *)stk_dateWithDate:(NSDate *)date time:(NSDate *)time;

@end
