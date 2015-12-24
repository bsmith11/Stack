//
//  STKHTMLSection.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKHTMLSection.h"
#import "STKHTMLParagraphSection.h"
#import "STKHTMLImageSection.h"
#import "STKHTMLVideoSection.h"

#import "NSString+STKHTML.h"
#import "NSAttributedString+STKHTML.h"
#import "NSMutableAttributedString+STKHTML.h"

#import <DTCoreText/DTCoreText.h>

NSString * kSTKHTMLOptionsKeyFontFamily = @"STKFontFamily";
NSString * kSTKHTMLOptionsKeyFontSize = @"STKFontSize";
NSString * kSTKHTMLOptionsKeyTextColor = @"STKTextColor";

@implementation STKHTMLSection

+ (NSArray *)sectionsFromHTML:(NSString *)html {
    return [self sectionsFromHTML:html options:nil encoding:NSUTF8StringEncoding];
}

+ (NSArray *)sectionsFromHTML:(NSString *)HTML options:(NSDictionary *)options {
    return [self sectionsFromHTML:HTML options:options encoding:NSUTF8StringEncoding];
}

+ (NSArray *)sectionsFromHTML:(NSString *)html options:(NSDictionary *)options encoding:(NSStringEncoding)encoding {
    NSString *fontFamily = options[kSTKHTMLOptionsKeyFontFamily] ?: [UIFont systemFontOfSize:[UIFont systemFontSize]].familyName;
    NSNumber *fontSize = options[kSTKHTMLOptionsKeyFontSize] ?: @([UIFont systemFontSize]);
    UIColor *textColor = options[kSTKHTMLOptionsKeyTextColor] ?: [UIColor blackColor];

    NSData *data = [html dataUsingEncoding:encoding];
    NSDictionary *builderOptions = @{DTDefaultFontFamily:fontFamily,
                                     DTDefaultFontSize:fontSize,
                                     DTDefaultTextColor:textColor};
    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data options:builderOptions documentAttributes:nil];
    NSAttributedString *generatedAttributedString = [stringBuilder generatedAttributedString];
    NSAttributedString *attributedString = [NSAttributedString stk_coreTextCleansedAttributedString:generatedAttributedString];

    return [self sectionsFromAttributedString:attributedString];
}

+ (NSArray *)sectionsFromAttributedString:(NSAttributedString *)attributedString {
    NSMutableArray *sections = [NSMutableArray array];
    __block NSInteger index = 0;

    [[attributedString string] enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        NSMutableAttributedString *attributedSubstring = [[attributedString attributedSubstringFromRange:substringRange] mutableCopy];
        [attributedSubstring stk_trimCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if (attributedSubstring.length > 0) {
            NSRange substringFullRange = NSMakeRange(0, attributedSubstring.length);
            __block BOOL didFindAttachment = NO;
            [attributedSubstring enumerateAttribute:NSAttachmentAttributeName inRange:substringFullRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stopBool) {
                if ([value isKindOfClass:[DTImageTextAttachment class]]) {
                    DTImageTextAttachment *imageTextAttachment = (DTImageTextAttachment *)value;
                    STKHTMLImageSection *section = [STKHTMLImageSection imageSectionWithImageTextAttachment:imageTextAttachment];

                    [sections addObject:section];
                    section.index = @(index);
                    index++;

                    *stopBool = YES;
                    didFindAttachment = YES;
                }
                else if ([value isKindOfClass:[DTIframeTextAttachment class]]) {
                    DTIframeTextAttachment *iframeTextAttachment = (DTIframeTextAttachment *)value;
                    STKHTMLVideoSection *section = [STKHTMLVideoSection videoSectionWithIframeTextAttachment:iframeTextAttachment];

                    [sections addObject:section];
                    section.index = @(index);
                    index++;

                    *stopBool = YES;
                    didFindAttachment = YES;
                }
                else if ([value isKindOfClass:[DTObjectTextAttachment class]]) {
                    DTObjectTextAttachment *objectTextAttachment = (DTObjectTextAttachment *)value;
                    STKHTMLVideoSection *section = [STKHTMLVideoSection videoSectionWithObjectTextAttachment:objectTextAttachment];

                    [sections addObject:section];
                    section.index = @(index);
                    index++;

                    *stopBool = YES;
                    didFindAttachment = YES;
                }
            }];

            if (!didFindAttachment) {
                __block BOOL didFindVideoURL = NO;
                [attributedSubstring enumerateAttributesInRange:substringFullRange options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stopBool) {
                    if (attrs[@"STKLink"] && NSEqualRanges(substringFullRange, range)) {
                        NSString *URLString = (NSString *)attrs[@"STKLink"];
                        
                        if ([URLString stk_isVideoURL]) {
                            STKHTMLVideoSection *section = [STKHTMLVideoSection videoSectionWithVideoURLString:URLString];
                            
                            [sections addObject:section];
                            section.index = @(index);
                            index++;
                            
                            *stopBool = YES;
                            didFindVideoURL = YES;
                        }
                    }
                }];
                
                if (!didFindVideoURL) {
                    STKHTMLParagraphSection *section = [[STKHTMLParagraphSection alloc] init];
                    
                    [attributedSubstring stk_setLineSpacing:8.0f];
                    section.content = attributedSubstring;
                    
                    [sections addObject:section];
                    section.index = @(index);
                    index++;
                }
            }
        }
    }];
    
    return sections;
}

@end
