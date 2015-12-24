//
//  NSMutableAttributedString+STKHTML.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface NSMutableAttributedString (STKHTML)



- (void)stk_trimCharactersFromSet:(NSCharacterSet *)set;
- (void)stk_trimBeginningCharactersFromSet:(NSCharacterSet *)set;
- (void)stk_trimEndingCharactersFromSet:(NSCharacterSet *)set;

- (void)stk_trimString:(NSString *)string;
- (void)stk_trimBeginningString:(NSString *)string;
- (void)stk_trimEndingString:(NSString *)string;

- (void)stk_setLineSpacing:(CGFloat)lineSpacing;
- (void)stk_setLinkColor:(UIColor *)color underlineStyle:(NSUnderlineStyle)underlineStyle;

@end
