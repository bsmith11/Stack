//
//  STKAttachment+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAttachment+RZImport.h"

#import "STKAPIWordpressConstants.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKAttachment (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIWordpressResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKAttachment, attachmentID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIWordpressResponseKeyID:RZDB_KP(STKAttachment, attachmentID),
             kSTKAPIWordpressResponseKeySource:RZDB_KP(STKAttachment, sourceURL)};
}

+ (NSArray *)rzi_ignoredKeys {
    return @[kSTKAPIWordpressResponseKeyAuthor, kSTKAPIWordpressResponseKeyCommentStatus, kSTKAPIWordpressResponseKeyContent, kSTKAPIWordpressResponseKeyDate, kSTKAPIWordpressResponseKeyDateGMT, kSTKAPIWordpressResponseKeyDateTZ,
             kSTKAPIWordpressResponseKeyExcerpt, kSTKAPIWordpressResponseKeyFormat, kSTKAPIWordpressResponseKeyGUID, kSTKAPIWordpressResponseKeyIsImage, kSTKAPIWordpressResponseKeyLink, kSTKAPIWordpressResponseKeyMenuOrder,
             kSTKAPIWordpressResponseKeyMeta, kSTKAPIWordpressResponseKeyModified, kSTKAPIWordpressResponseKeyModifiedGMT, kSTKAPIWordpressResponseKeyModifiedTZ, kSTKAPIWordpressResponseKeyParent, kSTKAPIWordpressResponseKeyPingStatus,
             kSTKAPIWordpressResponseKeySlug, kSTKAPIWordpressResponseKeyStatus, kSTKAPIWordpressResponseKeySticky, kSTKAPIWordpressResponseKeyTerms, kSTKAPIWordpressResponseKeyTitle, kSTKAPIWordpressResponseKeyType, kSTKAPIWordpressResponseKeyErrors, kSTKAPIWordpressResponseKeyErrorData];
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:kSTKAPIWordpressResponseKeyAttachmentMeta]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.width = value[kSTKAPIWordpressResponseKeyWidth];
            self.height = value[kSTKAPIWordpressResponseKeyHeight];
        }
        else {
            self.width = @0;
            self.height = @0;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
