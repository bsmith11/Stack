//
//  NSMutableAttributedString+STKHTML.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "NSMutableAttributedString+STKHTML.h"

@implementation NSMutableAttributedString (STKHTML)

- (void)stk_trimCharactersFromSet:(NSCharacterSet *)set {
    [self stk_trimBeginningCharactersFromSet:set];
    [self stk_trimEndingCharactersFromSet:set];
}

- (void)stk_trimBeginningCharactersFromSet:(NSCharacterSet *)set {
    NSMutableString *mutableString = [self mutableString];

    if (mutableString.length > 0) {
        NSRange startRange = NSMakeRange(0, 1);
        NSRange range = [mutableString rangeOfCharacterFromSet:set options:NSLiteralSearch range:startRange];

        if (range.location != NSNotFound) {
            [mutableString deleteCharactersInRange:range];

            [self stk_trimBeginningCharactersFromSet:set];
        }
    }
}

- (void)stk_trimEndingCharactersFromSet:(NSCharacterSet *)set {
    NSMutableString *mutableString = [self mutableString];

    if (mutableString.length > 0) {
        NSRange endRange = NSMakeRange(mutableString.length - 1, 1);
        NSRange range = [mutableString rangeOfCharacterFromSet:set options:NSLiteralSearch range:endRange];

        if (range.location != NSNotFound) {
            [mutableString deleteCharactersInRange:range];

            [self stk_trimEndingCharactersFromSet:set];
        }
    }
}

- (void)stk_trimString:(NSString *)string {
    [self stk_trimBeginningString:string];
    [self stk_trimEndingString:string];
}

- (void)stk_trimBeginningString:(NSString *)string {
    NSMutableString *mutableString = [self mutableString];

    while ([mutableString hasPrefix:string]) {
        [mutableString deleteCharactersInRange:NSMakeRange(0, string.length)];
    }
}

- (void)stk_trimEndingString:(NSString *)string {
    NSMutableString *mutableString = [self mutableString];

    while ([mutableString hasSuffix:string]) {
        [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - string.length, string.length)];
    }
}

- (void)stk_setLineSpacing:(CGFloat)lineSpacing {
    [self beginEditing];

    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSMutableDictionary *mutableAttributes = [attrs mutableCopy];

        NSParagraphStyle *paragraphStyle = attrs[NSParagraphStyleAttributeName];
        if (paragraphStyle) {
            NSMutableParagraphStyle *mutableParagraphStyle = [paragraphStyle mutableCopy];
            mutableParagraphStyle.lineSpacing = lineSpacing;

            mutableAttributes[NSParagraphStyleAttributeName] = mutableParagraphStyle;
        }

        [self setAttributes:mutableAttributes range:range];
    }];

    [self endEditing];
}

- (void)stk_setLinkColor:(UIColor *)color underlineStyle:(NSUnderlineStyle)underlineStyle {
    [self beginEditing];

    color = color ?: [UIColor blueColor];

    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSMutableDictionary *mutableAttributes = [attrs mutableCopy];

        if (mutableAttributes[@"STKLink"]) {
            if (underlineStyle == NSUnderlineStyleNone) {
                [mutableAttributes removeObjectForKey:NSUnderlineStyleAttributeName];
            }
            else {
                mutableAttributes[NSUnderlineStyleAttributeName] = @(underlineStyle);
            }

            mutableAttributes[NSForegroundColorAttributeName] = color;
        }
        
        [self setAttributes:mutableAttributes range:range];
    }];
    
    [self endEditing];
}

@end
