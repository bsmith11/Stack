//
//  STKRSSPost.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKRSSPost.h"
#import "STKAuthor.h"

#import "STKFormatter.h"
#import "STKAPIRSSConstants.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKRSSPost

+ (NSString *)rzv_externalPrimaryKey {
    return kSTKAPIRSSResponseKeyID;
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKRSSPost, postID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{kSTKAPIRSSResponseKeyID:RZDB_KP(STKRSSPost, postID),
             kSTKAPIRSSResponseKeyLink:RZDB_KP(STKRSSPost, link),
             kSTKAPIRSSResponseKeyCommentsRSS:RZDB_KP(STKRSSPost, commentsRSS)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:kSTKAPIRSSResponseKeyContent]) {
        if ([value isKindOfClass:[NSString class]]) {
            [self initializeSectionsFromHTML:value];
        }
        else {
            self.sections = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:kSTKAPIRSSResponseKeyTitle]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.title = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else {
            self.title = nil;
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
        if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
            self.author = [STKAuthor rzv_objectWithPrimaryKeyValue:value createNew:YES inContext:context];
            self.author.name = [value componentsSeparatedByString:@"_"].lastObject;
        }
        else {
            self.author = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
