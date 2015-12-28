//
//  STKSource.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSource.h"

#import "STKAPIWordpressConstants.h"
#import "STKAPIConstants.h"

#import "UIColor+STKStyle.h"

@implementation STKSource

+ (NSArray *)allSourceTypes {
    return @[@(STKSourceTypeSkyd),
             @(STKSourceTypeBamaSecs),
             @(STKSourceTypeUltiworld),
             @(STKSourceTypeAUDL),
             @(STKSourceTypeMLU),
             @(STKSourceTypeSludge)];
}

+ (NSArray *)sourcesWithNotificationsAvailable {
    return @[@(STKSourceTypeSkyd),
             @(STKSourceTypeBamaSecs),
             @(STKSourceTypeMLU)];
}

+ (STKSourceType)sourceTypeForName:(NSString *)name {
    __block STKSourceType sourceType = 0;

    [[self sourceNames] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:name]) {
            sourceType = [key integerValue];
            *stop = YES;
        }
    }];

    return sourceType;
}

+ (NSURL *)baseURLForType:(STKSourceType)type {
    return [self sourceBaseURLs][@(type)];
}

+ (NSDictionary *)sourceBaseURLs {
    static NSDictionary *sourceBaseURLs = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sourceBaseURLs = @{@(STKSourceTypeSkyd):[NSURL URLWithString:kSTKAPIBaseURLSkyd],
                           @(STKSourceTypeBamaSecs):[NSURL URLWithString:kSTKAPIBaseURLBamaSecs],
                           @(STKSourceTypeUltiworld):[NSURL URLWithString:kSTKAPIBaseURLUltiworld],
                           @(STKSourceTypeAUDL):[NSURL URLWithString:kSTKAPIBaseURLAUDL],
                           @(STKSourceTypeMLU):[NSURL URLWithString:kSTKAPIBaseURLMLU],
                           @(STKSourceTypeSludge):[NSURL URLWithString:kSTKAPIBaseURLBlogger]};
    });

    return sourceBaseURLs;
}

+ (NSString *)nameForType:(STKSourceType)type {
    return [self sourceNames][@(type)];
}

+ (NSDictionary *)sourceNames {
    static NSDictionary *sourceNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sourceNames = @{@(STKSourceTypeSkyd):@"Skyd Magazine",
                        @(STKSourceTypeBamaSecs):@"Bama Secs",
                        @(STKSourceTypeUltiworld):@"Ultiworld",
                        @(STKSourceTypeAUDL):@"AUDL",
                        @(STKSourceTypeMLU):@"MLU",
                        @(STKSourceTypeSludge):@"Sludge Brown"};
    });

    return sourceNames;
}

+ (NSString *)summaryForType:(STKSourceType)type {
    return [self sourceSummaries][@(type)];
}

+ (NSDictionary *)sourceSummaries {
    static NSDictionary *sourceSummaries = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sourceSummaries = @{@(STKSourceTypeSkyd):@"Founded in 2010, Skyd Magazine is dedicated to celebrating the sport of ultimate with honest, original content.",
                            @(STKSourceTypeBamaSecs):@"Bama Secs Summary",
                            @(STKSourceTypeUltiworld):@"Ultiworld is the premier news media site dedicated to the sport of Ultimate. From in-depth reporting to video highlights, we strive to bring you the most interesting and important stories from around the globe.",
                            @(STKSourceTypeAUDL):@"The American Ultimate Disc League (AUDL) is the first and largest professional ultimate league in the world. It strives to maintain the sport’s rich history, and its 26 franchises embody the robust spirit of ultimate's players, fans, and community alike. The league's mission is to increase the visibility of one of North America’s fastest growing sports by creating fun, family friendly events that showcase the sport being played at its highest level.",
                            @(STKSourceTypeMLU):@"Major League Ultimate is the national Professional Ultimate Frisbee league with 8 teams on the east and west coasts.",
                            @(STKSourceTypeSludge):@"Sludge Brown Summary"};
    });

    return sourceSummaries;
}

+ (NSString *)imageNameForType:(STKSourceType)type {
    return [self imageNames][@(type)];
}

+ (NSDictionary *)imageNames {
    static NSDictionary *imageNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageNames = @{@(STKSourceTypeSkyd):@"Skyd Source Image",
                       @(STKSourceTypeBamaSecs):@"Bama Secs Source Image",
                       @(STKSourceTypeUltiworld):@"Ultiworld Source Image",
                       @(STKSourceTypeAUDL):@"AUDL Source Image",
                       @(STKSourceTypeMLU):@"MLU Source Image",
                       @(STKSourceTypeSludge):@"Sludge Source Image"};
    });

    return imageNames;
}

+ (NSString *)bannerImageNameForType:(STKSourceType)type {
    return [self bannerImageNames][@(type)];
}

+ (NSDictionary *)bannerImageNames {
    static NSDictionary *bannerImageNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bannerImageNames = @{@(STKSourceTypeSkyd):@"Skyd Banner Image",
                             @(STKSourceTypeBamaSecs):@"Bama Secs Banner Image",
                             @(STKSourceTypeUltiworld):@"Ultiworld Banner Image",
                             @(STKSourceTypeAUDL):@"AUDL Banner Image",
                             @(STKSourceTypeMLU):@"MLU Banner Image",
                             @(STKSourceTypeSludge):@"Sludge Banner Image"};
    });

    return bannerImageNames;
}

+ (UIColor *)colorForType:(STKSourceType)type {
    UIColor *color = nil;

    switch (type) {
        case STKSourceTypeSkyd:
            color = [UIColor stk_skydColor];
            break;

        case STKSourceTypeBamaSecs:
            color = [UIColor stk_bamasecsColor];
            break;

        case STKSourceTypeUltiworld:
            color = [UIColor stk_ultiworldColor];
            break;

        case STKSourceTypeAUDL:
            color = [UIColor stk_audlColor];
            break;

        case STKSourceTypeMLU:
            color = [UIColor stk_mluColor];
            break;

        case STKSourceTypeSludge:
            color = [UIColor stk_sludgeColor];
            break;

        default:
            color = [UIColor stk_stackColor];
            break;
    }

    return color;
}

+ (STKBackendType)backendTypeForType:(STKSourceType)type {
    return [[self backendTypes][@(type)] integerValue];
}

+ (NSDictionary *)backendTypes {
    static NSDictionary *backendTypes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        backendTypes = @{@(STKSourceTypeSkyd):@(STKBackendTypeWordpress),
                         @(STKSourceTypeBamaSecs):@(STKBackendTypeWordpress),
                         @(STKSourceTypeUltiworld):@(STKBackendTypeRSS),
                         @(STKSourceTypeAUDL):@(STKBackendTypeRSS),
                         @(STKSourceTypeMLU):@(STKBackendTypeWordpress),
                         @(STKSourceTypeSludge):@(STKBackendTypeBlogger)};
    });

    return backendTypes;
}

+ (BOOL)notificationsAvailableForType:(STKSourceType)type {
    return (type == STKSourceTypeSkyd ||
            type == STKSourceTypeBamaSecs ||
            type == STKSourceTypeMLU);
}

#pragma mark - Wordpress Prefixing

+ (NSString *)prefixWithType:(STKSourceType)type {
    return [NSString stringWithFormat:@"%@_", @(type)];
}

+ (NSString *)prefixedIDFromID:(NSNumber *)ID type:(STKSourceType)type {
    NSString *prefixedID = [NSString stringWithFormat:@"%@%@", [self prefixWithType:type], ID.stringValue];

    return prefixedID;
}

+ (void)prefixIDInDicationary:(NSMutableDictionary *)mutableDictionary type:(STKSourceType)type {
    NSNumber *oldID = mutableDictionary[kSTKAPIWordpressResponseKeyID];
    NSString *newID = [self prefixedIDFromID:oldID type:type];

    mutableDictionary[kSTKAPIWordpressResponseKeyID] = newID;
}

+ (NSDictionary *)prefixedPostDictionaryFromDictionary:(NSDictionary *)dictionary type:(STKSourceType)type {
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    [self prefixIDInDicationary:mutableDictionary type:type];

    NSDictionary *authorDictionary = mutableDictionary[kSTKAPIWordpressResponseKeyAuthor];
    if (authorDictionary && ![authorDictionary isKindOfClass:[NSNull class]]) {
        NSMutableDictionary *mutableAuthorDictionary = [authorDictionary mutableCopy];
        [self prefixIDInDicationary:mutableAuthorDictionary type:type];
        mutableDictionary[kSTKAPIWordpressResponseKeyAuthor] = [mutableAuthorDictionary copy];
    }

    NSDictionary *attachmentDictionary = mutableDictionary[kSTKAPIWordpressResponseKeyFeaturedImage];
    if (attachmentDictionary && ![attachmentDictionary isKindOfClass:[NSNull class]]) {
        NSMutableDictionary *mutableAttachmentDictionary = [attachmentDictionary mutableCopy];
        [self prefixIDInDicationary:mutableAttachmentDictionary type:type];
        mutableDictionary[kSTKAPIWordpressResponseKeyFeaturedImage] = [mutableAttachmentDictionary copy];
    }

    return [mutableDictionary copy];
}

+ (NSArray *)prefixedArrayOfPostDictionariesFromArray:(NSArray *)array type:(STKSourceType)type {
    NSMutableArray *mutableArray = [NSMutableArray array];

    for (NSDictionary *postDictionary in array) {
        [mutableArray addObject:[self prefixedPostDictionaryFromDictionary:postDictionary type:type]];
    }

    return [mutableArray copy];
}

+ (NSDictionary *)prefixedCommentDictionaryFromDictionary:(NSDictionary *)dictionary type:(STKSourceType)type {
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    [self prefixIDInDicationary:mutableDictionary type:type];

    NSDictionary *authorDictionary = mutableDictionary[kSTKAPIWordpressResponseKeyAuthor];
    if (authorDictionary && ![authorDictionary isKindOfClass:[NSNull class]]) {
        NSMutableDictionary *mutableAuthorDictionary = [authorDictionary mutableCopy];
        [self prefixIDInDicationary:mutableAuthorDictionary type:type];
        mutableDictionary[kSTKAPIWordpressResponseKeyAuthor] = [mutableAuthorDictionary copy];
    }

    NSDictionary *attachmentDictionary = mutableDictionary[kSTKAPIWordpressResponseKeyFeaturedImage];
    if (attachmentDictionary && ![attachmentDictionary isKindOfClass:[NSNull class]]) {
        NSMutableDictionary *mutableAttachmentDictionary = [attachmentDictionary mutableCopy];
        [self prefixIDInDicationary:mutableAttachmentDictionary type:type];
        mutableDictionary[kSTKAPIWordpressResponseKeyFeaturedImage] = [mutableAttachmentDictionary copy];
    }

    return [mutableDictionary copy];
}

+ (NSArray *)prefixedArrayOfCommentDictionariesFromArray:(NSArray *)array type:(STKSourceType)type {
    NSMutableArray *mutableArray = [NSMutableArray array];

    for (NSDictionary *commentDictionary in array) {
        [mutableArray addObject:[self prefixedCommentDictionaryFromDictionary:commentDictionary type:type]];
    }
    
    return [mutableArray copy];
}

@end
