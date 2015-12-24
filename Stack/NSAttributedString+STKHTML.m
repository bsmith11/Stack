//
//  NSAttributedString+STKHTML.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import CoreText;

#import "NSAttributedString+STKHTML.h"
#import "NSParagraphStyle+STKHTML.h"
#import "NSMutableAttributedString+STKHTML.h"

#import <DTCoreText/DTCoreText.h>

@implementation NSAttributedString (STKHTML)

+ (NSArray *)coreTextKeys {
    static NSArray *coreTextKeys = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        coreTextKeys = @[DTTextListsAttribute,
                         DTAttachmentParagraphSpacingAttribute,
                         DTLinkHighlightColorAttribute,
                         DTAnchorAttribute,
                         DTGUIDAttribute,
                         DTHeaderLevelAttribute,
                         DTStrikeOutAttribute,
                         DTBackgroundColorAttribute,
                         DTShadowsAttribute,
                         DTHorizontalRuleStyleAttribute,
                         DTTextBlocksAttribute,
                         DTFieldAttribute,
                         DTCustomAttributesAttribute,
                         DTAscentMultiplierAttribute,
                         DTBackgroundStrokeColorAttribute,
                         DTBackgroundStrokeWidthAttribute,
                         DTBackgroundCornerRadiusAttribute,
                         (NSString *)kCTRubyAnnotationAttributeName,
                         (NSString *)kCTWritingDirectionAttributeName,
                         (NSString *)kCTBaselineReferenceInfoAttributeName,
                         (NSString *)kCTBaselineInfoAttributeName,
                         (NSString *)kCTBaselineClassAttributeName,
                         (NSString *)kCTRunDelegateAttributeName,
                         (NSString *)kCTLanguageAttributeName,
                         (NSString *)kCTCharacterShapeAttributeName,
                         (NSString *)kCTGlyphInfoAttributeName,
                         (NSString *)kCTVerticalFormsAttributeName,
                         (NSString *)kCTUnderlineColorAttributeName,
                         (NSString *)kCTSuperscriptAttributeName,
                         (NSString *)kCTUnderlineStyleAttributeName,
                         (NSString *)kCTStrokeColorAttributeName,
                         (NSString *)kCTStrokeWidthAttributeName,
                         (NSString *)kCTLigatureAttributeName,
                         (NSString *)kCTKernAttributeName,
                         (NSString *)kCTForegroundColorFromContextAttributeName];
    });

    return coreTextKeys;
}

+ (NSAttributedString *)stk_coreTextCleansedAttributedString:(NSAttributedString *)attributedString {
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    NSArray *coreTextKeys = [[self class] coreTextKeys];

    void (^block)(NSDictionary *, NSRange, BOOL *) = ^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSMutableDictionary *mutableAttributes = [attrs mutableCopy];

        [attrs enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stopBool) {
            if ([coreTextKeys containsObject:key]) {
                [mutableAttributes removeObjectForKey:key];
            }
            else if ([key isEqualToString:(NSString *)kCTParagraphStyleAttributeName]) {
                CTParagraphStyleRef paragraphStyleRef = (CTParagraphStyleRef)obj;
                NSParagraphStyle *paragraphStyle = [NSParagraphStyle stk_paragraphStyleFromCTParagraphStyle:paragraphStyleRef];

                //kCTParagraphStyleAttributeName and NSParagraphStyleAttributeName are the same value
                [mutableAttributes setObject:paragraphStyle forKey:key];
            }
            else if ([key isEqualToString:(NSString *)kCTForegroundColorAttributeName]) {
                CGColorRef colorRef = (__bridge CGColorRef)mutableAttributes[(NSString *)kCTForegroundColorAttributeName];
                if (colorRef) {
                    UIColor *color = [UIColor colorWithCGColor:colorRef];
                    [mutableAttributes setObject:color forKey:NSForegroundColorAttributeName];
                }

                [mutableAttributes removeObjectForKey:key];
            }
            else if ([key isEqualToString:NSLinkAttributeName]) {
                id value = mutableAttributes[key];
                NSString *URLString = [value isKindOfClass:[NSURL class]] ? [value absoluteString] : value;

                //Async Display Kit doesn't respect custom attributes for NSLinkAttributeName links, so we use a custom one
                [mutableAttributes setObject:URLString forKey:@"STKLink"];
                [mutableAttributes removeObjectForKey:key];
            }
        }];

        [mutableAttributedString setAttributes:mutableAttributes range:range];
    };

    [mutableAttributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length)
                                                options:0
                                             usingBlock:block];

    //Replace line space separator unicode char with paragraph space separator unicode char so we can separator each paragraph
    [[mutableAttributedString mutableString] replaceOccurrencesOfString:@"\u2028"
                                                             withString:@"\u2029"
                                                                options:0
                                                                  range:NSMakeRange(0, mutableAttributedString.length)];

    [mutableAttributedString stk_trimCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return [mutableAttributedString copy];
}

@end
