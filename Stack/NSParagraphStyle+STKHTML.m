//
//  NSParagraphStyle+STKHTML.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "NSParagraphStyle+STKHTML.h"

@implementation NSParagraphStyle (STKHTML)

+ (instancetype)stk_paragraphStyleFromCTParagraphStyle:(CTParagraphStyleRef)paragraphStyleRef {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    CTTextAlignment alignment;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment)) {
        paragraphStyle.alignment = NSTextAlignmentFromCTTextAlignment(alignment);
    }

    CGFloat firstLineHeadIndent;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent)) {
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    }

    CGFloat headIndent;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent)) {
        paragraphStyle.headIndent = headIndent;
    }

    CGFloat tailIndent;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent)) {
        paragraphStyle.tailIndent = tailIndent;
    }

    CGFloat defaultTabInterval;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierDefaultTabInterval, sizeof(CGFloat), &defaultTabInterval)) {
        paragraphStyle.defaultTabInterval = defaultTabInterval;
    }

    CTLineBreakMode lineBreakMode;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode)) {
        paragraphStyle.lineBreakMode = (NSLineBreakMode)lineBreakMode;
    }

    CGFloat lineHeightMultiple;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple)) {
        paragraphStyle.lineHeightMultiple = lineHeightMultiple;
    }

    CGFloat maximumLineHeight;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight)) {
        paragraphStyle.maximumLineHeight = maximumLineHeight;
    }

    CGFloat minimumLineHeight;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight)) {
        paragraphStyle.minimumLineHeight = minimumLineHeight;
    }

    CGFloat lineSpacing;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing)) {
        paragraphStyle.lineSpacing = lineSpacing;
    }

    CGFloat paragraphSpacing;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing)) {
        paragraphStyle.paragraphSpacing = paragraphSpacing;
    }

    CGFloat paragraphSpacingBefore;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore)) {
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore;
    }

    CGFloat baseWritingDirection;
    if (CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CGFloat), &baseWritingDirection)) {
        paragraphStyle.baseWritingDirection = baseWritingDirection;
    }
    
    return [paragraphStyle copy];
}

@end
