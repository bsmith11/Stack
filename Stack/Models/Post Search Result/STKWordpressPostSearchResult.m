//
//  STKWordpressPostSearchResult.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKWordpressPostSearchResult.h"

#import "STKAPIWordpressConstants.h"
#import "STKFormatter.h"

#import <RZDataBinding/RZDBMacros.h>
#import <DTCoreText/DTCoreText.h>
#import <RZImport/NSObject+RZImport.h>

@implementation STKWordpressPostSearchResult

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIWordpressResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKPostSearchResult, postID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIWordpressResponseKeyID:RZDB_KP(STKPostSearchResult, postID)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIWordpressResponseKeyDateGMT, kSTKAPIWordpressResponseKeyDateTZ, kSTKAPIWordpressResponseKeyFormat,
             kSTKAPIWordpressResponseKeyGUID, kSTKAPIWordpressResponseKeyMenuOrder, kSTKAPIWordpressResponseKeyMeta,
             kSTKAPIWordpressResponseKeyModifiedGMT, kSTKAPIWordpressResponseKeyModifiedTZ, kSTKAPIWordpressResponseKeyParent,
             kSTKAPIWordpressResponseKeyPingStatus, kSTKAPIWordpressResponseKeySlug, kSTKAPIWordpressResponseKeySticky,
             kSTKAPIWordpressResponseKeyTerms, kSTKAPIWordpressResponseKeyType, kSTKAPIWordpressResponseKeyStatus, kSTKAPIWordpressResponseKeyExcerpt, kSTKAPIWordpressResponseKeyCommentStatus, kSTKAPIWordpressResponseKeyAuthor, kSTKAPIWordpressResponseKeyFeaturedImage, kSTKAPIWordpressResponseKeyLink, kSTKAPIWordpressResponseKeyContent];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kSTKAPIWordpressResponseKeyTitle]) {
        if ([value isKindOfClass:[NSString class]]) {
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *options;
            DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data options:options documentAttributes:nil];

            self.title = [[[stringBuilder generatedAttributedString] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else {
            self.title = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIWordpressResponseKeyDate]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.createDate = [[STKFormatter wordpressDateFormatter] dateFromString:value];
        }
        else {
            self.createDate = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIWordpressResponseKeyModified]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.modifyDate = [[STKFormatter wordpressDateFormatter] dateFromString:value];
        }
        else {
            self.modifyDate = nil;
        }

        return NO;
    }

    return YES;
}

@end
