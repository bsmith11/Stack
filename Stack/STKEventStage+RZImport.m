//
//  STKEventStage+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventStage+RZImport.h"

#import "STKEventGame.h"

#import "NSDate+STKTimeSince.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventStage (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return @"StageId";
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKEventStage, stageID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"StageId":RZDB_KP(STKEventStage, stageID),
             @"StageName":RZDB_KP(STKEventStage, name)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"Games"]) {
        for (STKEventGame *game in self.games) {
            [context deleteObject:game];
        }

        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *gamesArray = [STKEventGame rzi_objectsFromArray:value inContext:context];

            [gamesArray enumerateObjectsUsingBlock:^(STKEventGame *game, NSUInteger idx, BOOL *stop) {
                game.startDateFull = [NSDate stk_dateWithDate:game.startDate time:game.startTime];
                game.sortOrder = @(idx);
            }];

            self.games = [NSSet setWithArray:gamesArray];
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
