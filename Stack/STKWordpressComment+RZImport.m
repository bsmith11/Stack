//
//  STKWordpressComment+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKWordpressComment+RZImport.h"
#import "STKWordpressPost.h"

#import "STKFormatter.h"
#import "STKAPIWordpressConstants.h"
#import "NSAttributedString+STKHTML.h"
#import "UIColor+STKStyle.h"
#import "STKAttributes.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>
#import <DTCoreText/DTCoreText.h>
#import <RZUtils/RZCommonUtils.h>

@implementation STKWordpressComment (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIWordpressResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKWordpressComment, commentID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIWordpressResponseKeyID:RZDB_KP(STKWordpressComment, commentID)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIWordpressResponseKeyDateGMT, kSTKAPIWordpressResponseKeyDateTZ, kSTKAPIWordpressResponseKeyMeta, kSTKAPIWordpressResponseKeyType, kSTKAPIWordpressResponseKeyStatus, kSTKAPIWordpressResponseKeyParent, kSTKAPIWordpressResponseKeyPost];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:kSTKAPIWordpressResponseKeyAuthor]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.authorAvatarImageURL = RZNSNullToNil(value[kSTKAPIWordpressResponseKeyAvatar]);
            self.authorName = RZNSNullToNil(value[kSTKAPIWordpressResponseKeyName]);
        }
        else {
            self.authorAvatarImageURL = nil;
            self.authorName = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIWordpressResponseKeyContent]) {
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
    else if ([key isEqualToString:kSTKAPIWordpressResponseKeyDate]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.createDate = [[STKFormatter wordpressDateFormatter] dateFromString:value];
        }
        else {
            self.createDate = nil;
        }

        return NO;
    }
    
    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
