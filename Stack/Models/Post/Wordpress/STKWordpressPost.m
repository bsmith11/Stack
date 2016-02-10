//
//  STKWordpressPost.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKWordpressPost.h"

#import "STKFormatter.h"
#import "STKAPIWordpressConstants.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>
#import <DTCoreText/DTCoreText.h>

@implementation STKWordpressPost

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIWordpressResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKPost, postID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIWordpressResponseKeyID:RZDB_KP(STKPost, postID),
             kSTKAPIWordpressResponseKeyAuthor:RZDB_KP(STKPost, author),
             kSTKAPIWordpressResponseKeyFeaturedImage:RZDB_KP(STKPost, attachment),
             kSTKAPIWordpressResponseKeyLink:RZDB_KP(STKPost, link)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIWordpressResponseKeyDateGMT, kSTKAPIWordpressResponseKeyDateTZ, kSTKAPIWordpressResponseKeyFormat,
             kSTKAPIWordpressResponseKeyGUID, kSTKAPIWordpressResponseKeyMenuOrder, kSTKAPIWordpressResponseKeyMeta,
             kSTKAPIWordpressResponseKeyModifiedGMT, kSTKAPIWordpressResponseKeyModifiedTZ, kSTKAPIWordpressResponseKeyParent,
             kSTKAPIWordpressResponseKeyPingStatus, kSTKAPIWordpressResponseKeySlug, kSTKAPIWordpressResponseKeySticky,
             kSTKAPIWordpressResponseKeyTerms, kSTKAPIWordpressResponseKeyType, kSTKAPIWordpressResponseKeyStatus, kSTKAPIWordpressResponseKeyExcerpt, kSTKAPIWordpressResponseKeyCommentStatus];
}

+ (NSArray *)rzi_orderedKeys {
    return @[kSTKAPIWordpressResponseKeyFeaturedImage];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([value isEqual:[NSNull null]]) {
        return NO;
    }
    else {
        if ([key isEqualToString:kSTKAPIWordpressResponseKeyContent]) {
            [self initializeSectionsFromHTML:value];

            return NO;
        }
        else if ([key isEqualToString:kSTKAPIWordpressResponseKeyTitle]) {
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *options;
            DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data options:options documentAttributes:nil];
            
            self.title = [[[stringBuilder generatedAttributedString] string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            return NO;
        }
        else if ([key isEqualToString:kSTKAPIWordpressResponseKeyDate] && [value isKindOfClass:[NSString class]]) {
            self.createDate = [[STKFormatter wordpressDateFormatter] dateFromString:value];

            return NO;
        }
        else if ([key isEqualToString:kSTKAPIWordpressResponseKeyModified] && [value isKindOfClass:[NSString class]]) {
            self.modifyDate = [[STKFormatter wordpressDateFormatter] dateFromString:value];

            return NO;
        }

        return [super rzi_shouldImportValue:value forKey:key inContext:context];
    }
}

@end
