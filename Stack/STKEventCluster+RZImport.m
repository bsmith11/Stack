//
//  STKEventCluster+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventCluster+RZImport.h"

#import "STKEventGame.h"

#import "NSDate+STKTimeSince.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventCluster (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return @"ClusterId";
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKEventCluster, clusterID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"ClusterId":RZDB_KP(STKEventCluster, clusterID),
             @"Name":RZDB_KP(STKEventCluster, name)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"Games"]) {
        for (STKEventGame *game in self.games) {
            [context deleteObject:game];
        }

        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *games = [NSSet setWithArray:[STKEventGame rzi_objectsFromArray:value inContext:context]];
            for (STKEventGame *game in games) {
                game.startDateFull = [NSDate stk_dateWithDate:game.startDate time:game.startTime];
            }

            self.games = games;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
