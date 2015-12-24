//
//  STKBloggerComment+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBloggerComment+RZImport.h"
#import "STKBloggerPost.h"

#import "STKFormatter.h"
#import "STKAPIBloggerConstants.h"
#import "NSAttributedString+STKHTML.h"
#import "UIColor+STKStyle.h"
#import "STKAttributes.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>
#import <DTCoreText/DTCoreText.h>
#import <RZUtils/RZCommonUtils.h>

@implementation STKBloggerComment (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIBloggerResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKBloggerComment, commentID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIBloggerResponseKeyID:RZDB_KP(STKBloggerComment, commentID)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIBloggerResponseKeyUpdated,
             kSTKAPIBloggerResponseKeySelfLink,
             kSTKAPIBloggerResponseKeyKind,
             kSTKAPIBloggerResponseKeyBlog];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:kSTKAPIBloggerResponseKeyContent]) {
        if ([value isKindOfClass:[NSString class]]) {
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *attributes = [STKAttributes stk_commentNodeBodyAttributes];
            UIFont *font = attributes[NSFontAttributeName];
            NSDictionary *options = @{DTDefaultFontFamily:font.familyName,
                                      DTDefaultFontSize:@(font.pointSize),
                                      DTDefaultTextColor:[UIColor stk_stackColor]};
            DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data options:options documentAttributes:nil];
            NSAttributedString *generatedAttributedString = [stringBuilder generatedAttributedString];
            NSAttributedString *attributedString = [NSAttributedString stk_coreTextCleansedAttributedString:generatedAttributedString];

            self.content = [NSKeyedArchiver archivedDataWithRootObject:attributedString];
        }
        else {
            self.content = nil;
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

            self.authorName = RZNSNullToNil(authorDictionary[kSTKAPIBloggerResponseKeyDisplayName]);
            NSDictionary *imageDictionary = RZNSNullToNil(authorDictionary[kSTKAPIBloggerResponseKeyImage]);
            if (imageDictionary) {
                self.authorAvatarImageURL = RZNSNullToNil(imageDictionary[kSTKAPIBloggerResponseKeyURL]);
            }
            else {
                self.authorAvatarImageURL = nil;
            }
        }
        else {
            self.authorName = nil;
            self.authorAvatarImageURL = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIBloggerResponseKeyPost]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *postDictionary = (NSDictionary *)value;
            NSString *postID = RZNSNullToNil(postDictionary[kSTKAPIBloggerResponseKeyID]);

            if (postID) {
                self.post = [STKBloggerPost rzv_objectWithPrimaryKeyValue:postID createNew:YES inContext:context];
            }
            else {
                self.post = nil;
            }
        }
        else {
            self.post = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
