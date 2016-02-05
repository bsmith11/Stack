//
//  STKEventPool+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPool+RZImport.h"

#import "STKEventStanding.h"
#import "STKEventGame.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventPool (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return @"PoolId";
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKEventPool, poolID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"PoolId":RZDB_KP(STKEventPool, poolID),
             @"Name":RZDB_KP(STKEventPool, name)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"Games"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *games = [NSSet setWithArray:[STKEventGame rzi_objectsFromArray:value inContext:context]];
            self.games = games;
        }
        else {
            self.games = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:@"Standings"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *standings = [NSSet setWithArray:[STKEventStanding rzi_objectsFromArray:value inContext:context]];
            self.standings = standings;
        }
        else {
            self.standings = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
