//
//  STKRSSComment+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKRSSComment+RZImport.h"
#import "STKRSSPost.h"

#import "STKFormatter.h"
#import "STKAPIRSSConstants.h"
#import "NSAttributedString+STKHTML.h"
#import "UIColor+STKStyle.h"
#import "STKAttributes.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>
#import <DTCoreText/DTCoreText.h>
#import <RZUtils/RZCommonUtils.h>

@implementation STKRSSComment (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIRSSResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKRSSComment, commentID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIRSSResponseKeyID:RZDB_KP(STKRSSComment, commentID)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:kSTKAPIRSSResponseKeyContent]) {
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
    else if ([key isEqualToString:kSTKAPIRSSResponseKeyCreateDate]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.createDate = [[STKFormatter wordpressDateFormatter] dateFromString:value];
        }
        else {
            self.createDate = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIRSSResponseKeyAuthor]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.authorName = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else {
            self.authorName = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIRSSResponseKeyPostID]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.post = [STKRSSPost rzv_objectWithPrimaryKeyValue:value createNew:YES inContext:context];
        }
        else {
            self.post = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
