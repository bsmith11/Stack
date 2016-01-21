//
//  NSURL+STKExtensions.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@interface NSURL (STKExtensions)

- (BOOL)stk_isMailLink;
- (NSString *)stk_emailAddress;

@end
