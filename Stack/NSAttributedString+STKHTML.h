//
//  NSAttributedString+STKHTML.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@interface NSAttributedString (STKHTML)

+ (NSAttributedString *)stk_coreTextCleansedAttributedString:(NSAttributedString *)attributedString;

@end
