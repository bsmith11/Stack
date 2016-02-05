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
            self.pools = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:@"Brackets"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *brackets = [NSSet setWithArray:[STKEventBracket rzi_objectsFromArray:value inContext:context]];
            self.brackets = brackets;
        }
        else {
            self.brackets = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
