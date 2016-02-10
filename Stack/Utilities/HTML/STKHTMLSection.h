//
//  STKHTMLSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

OBJC_EXTERN NSString * kSTKHTMLOptionsKeyFontFamily;
OBJC_EXTERN NSString * kSTKHTMLOptionsKeyFontSize;
OBJC_EXTERN NSString * kSTKHTMLOptionsKeyTextColor;

@interface STKHTMLSection : NSObject

+ (NSArray *)sectionsFromHTML:(NSString *)HTML;
+ (NSArray *)sectionsFromHTML:(NSString *)HTML options:(NSDictionary *)options;
+ (NSArray *)sectionsFromHTML:(NSString *)HTML options:(NSDictionary *)options encoding:(NSStringEncoding)encoding;

@property (strong, nonatomic) NSNumber *index;

@end
