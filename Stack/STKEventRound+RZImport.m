//
//  STKEventRound+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventRound+RZImport.h"

#import "STKEventPool.h"
#import "STKEventBracket.h"
#import "STKEventCluster.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventRound (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return @"RoundId";
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKEventRound, roundID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"RoundId":RZDB_KP(STKEventRound, roundID)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"Pools"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *pools = [NSSet setWithArray:[STKEventPool rzi_objectsFromArray:value inContext:context]];
            self.pools = pools;
        }
        else {
            for (STKEventPool *pool in self.pools) {
                [context deleteObject:pool];
            }
        }

        return NO;
    }
    else if ([key isEqualToString:@"Brackets"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *bracketsArray = [STKEventBracket rzi_objectsFromArray:value inContext:context];

            [bracketsArray enumerateObjectsUsingBlock:^(STKEventBracket *bracket, NSUInteger idx, BOOL *stop) {
                bracket.sortOrder = @(idx);
            }];

            self.brackets = [NSSet setWithArray:bracketsArray];
        }
        else {
            for (STKEventBracket *bracket in self.brackets) {
                [context deleteObject:bracket];
            }
        }

        return NO;
    }
    else if ([key isEqualToString:@"Clusters"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *clusters = [NSSet setWithArray:[STKEventCluster rzi_objectsFromArray:value inContext:context]];
            self.clusters = clusters;
        }
        else {
            for (STKEventCluster *cluster in self.clusters) {
                [context deleteObject:cluster];
            }
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
