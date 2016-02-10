//
//  STKBloggerPost.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBloggerPost.h"
#import "STKAuthor.h"

#import "STKFormatter.h"
#import "STKAPIBloggerConstants.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>
#import <RZUtils/RZCommonUtils.h>

@implementation STKBloggerPost

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIBloggerResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKBloggerPost, postID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIBloggerResponseKeyID:RZDB_KP(STKBloggerPost, postID),
             kSTKAPIBloggerResponseKeyURL:RZDB_KP(STKBloggerPost, link)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIBloggerResponseKeyUpdated,
             kSTKAPIBloggerResponseKeySelfLink,
             kSTKAPIBloggerResponseKeyLabels,
             kSTKAPIBloggerResponseKeyReplies,
             kSTKAPIBloggerResponseKeyBlog,
             kSTKAPIBloggerResponseKeyImages,
             kSTKAPIBloggerResponseKeyKind,
             kSTKAPIBloggerResponseKeyETag];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:kSTKAPIBloggerResponseKeyContent]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self initializeSectionsFromHTML:value];
        }
        else {
            self.sections = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIBloggerResponseKeyTitle]) {
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
    else if ([key isEqualToString:kSTKAPIBloggerResponseKeyAuthor]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *authorDictionary = (NSDictionary *)value;
            NSString *authorID = RZNSNullToNil(authorDictionary[kSTKAPIBloggerResponseKeyID]);

            if (authorID.length > 0) {
                self.author = [STKAuthor rzv_objectWithPrimaryKeyValue:authorID createNew:YES inContext:context];
                self.author.name = RZNSNullToNil(authorDictionary[kSTKAPIBloggerResponseKeyDisplayName]);

                NSDictionary *imageDictionary = RZNSNullToNil(authorDictionary[kSTKAPIBloggerResponseKeyImage]);
                if (imageDictionary) {
                    self.author.avatarImageURL = RZNSNullToNil(imageDictionary[kSTKAPIBloggerResponseKeyURL]);
                }
            }
            else {
                self.author = nil;
            }
        }
        else {
            self.author = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
