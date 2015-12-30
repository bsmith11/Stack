//
//  STKSource.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, STKSourceType) {
    STKSourceTypeSkyd,
    STKSourceTypeBamaSecs,
    STKSourceTypeUltiworld,
    STKSourceTypeAUDL,
    STKSourceTypeMLU,
    STKSourceTypeSludge
};

typedef NS_ENUM(NSInteger, STKBackendType) {
    STKBackendTypeWordpress,
    STKBackendTypeRSS,
    STKBackendTypeBlogger
};

@interface STKSource : NSObject

+ (NSArray *)allSourceTypes;
+ (NSArray *)sourcesWithSearchAvailable;
+ (NSArray *)sourcesWithNotificationsAvailable;

+ (STKSourceType)sourceTypeForName:(NSString *)name;
+ (NSURL *)baseURLForType:(STKSourceType)type;
+ (NSString *)nameForType:(STKSourceType)type;
+ (NSString *)summaryForType:(STKSourceType)type;
+ (NSString *)imageNameForType:(STKSourceType)type;
+ (NSString *)bannerImageNameForType:(STKSourceType)type;
+ (UIColor *)colorForType:(STKSourceType)type;
+ (STKBackendType)backendTypeForType:(STKSourceType)type;

@end
