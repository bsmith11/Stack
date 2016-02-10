//
//  STKAuthor+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAuthor+RZImport.h"

#import "STKAPIWordpressConstants.h"
#import "NSAttributedString+STKHTML.h"
#import "UIColor+STKStyle.h"
#import "STKAttributes.h"

#import <RZDataBinding/RZDBMacros.h>
#import <RZVinyl/RZVinyl.h>
#import <DTCoreText/DTCoreText.h>

@implementation STKAuthor (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIWordpressResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKAuthor, authorID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIWordpressResponseKeyID:RZDB_KP(STKAuthor, authorID),
             kSTKAPIWordpressResponseKeyAvatar:RZDB_KP(STKAuthor, avatarImageURL),
             kSTKAPIWordpressResponseKeyName:RZDB_KP(STKAuthor, name),
             kSTKAPIWordpressResponseKeyDescription:RZDB_KP(STKAuthor, summary)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIWordpressResponseKeyURL, kSTKAPIWordpressResponseKeyFirstName, kSTKAPIWordpressResponseKeyLastName, kSTKAPIWordpressResponseKeyMeta, kSTKAPIWordpressResponseKeyNickname, kSTKAPIWordpressResponseKeyRegistered,
             kSTKAPIWordpressResponseKeySlug, kSTKAPIWordpressResponseKeyUsername];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:kSTKAPIWordpressResponseKeyDescription]) {
        if ([value isKindOfClass:[NSString class]]) {
            NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *attributes = [STKAttributes stk_authorSummaryAttributes];
            UIFont *font = attributes[NSFontAttributeName];
            NSDictionary *options = @{DTDefaultFontFamily:font.familyName,
                                      DTDefaultFontSize:@(font.pointSize),
                                      DTDefaultTextColor:[UIColor stk_stackColor]};
            DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data options:options documentAttributes:nil];
            NSAttributedString *generatedAttributedString = [stringBuilder generatedAttributedString];
            NSAttributedString *attributedString = [NSAttributedString stk_coreTextCleansedAttributedString:generatedAttributedString];
            attributedString = [NSAttributedString stk_attributedStringByRemovingAttachmentsFromString:attributedString];

            self.summary = [NSKeyedArchiver archivedDataWithRootObject:attributedString];
        }
        else {
            self.summary = nil;
        }

        return NO;
    }
    
    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
