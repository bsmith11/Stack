//
//  STKBloggerPostSearchResult.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBloggerPostSearchResult.h"

#import "STKFormatter.h"
#import "STKAPIBloggerConstants.h"

#import <RZDataBinding/RZDBMacros.h>
#import <RZImport/NSObject+RZImport.h>

@implementation STKBloggerPostSearchResult

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIBloggerResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKBloggerPostSearchResult, postID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIBloggerResponseKeyID:RZDB_KP(STKBloggerPostSearchResult, postID)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIBloggerResponseKeyUpdated,
             kSTKAPIBloggerResponseKeySelfLink,
             kSTKAPIBloggerResponseKeyLabels,
             kSTKAPIBloggerResponseKeyReplies,
             kSTKAPIBloggerResponseKeyBlog,
             kSTKAPIBloggerResponseKeyImages,
             kSTKAPIBloggerResponseKeyKind,
             kSTKAPIBloggerResponseKeyETag,
             kSTKAPIBloggerResponseKeyURL,
             kSTKAPIBloggerResponseKeyContent,
             kSTKAPIBloggerResponseKeyAuthor];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kSTKAPIBloggerResponseKeyTitle]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.title = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else {
            self.title = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIBloggerResponseKeyPublished]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.createDate = [[STKFormatter bloggerDateFormatter] dateFromString:value];
        }
        else {
            self.createDate = nil;
        }

        return NO;
    }

    return YES;
}

@end
