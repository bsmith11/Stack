//
//  STKEventStanding+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventStanding+RZImport.h"

#import "NSString+STKHTML.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventStanding (RZImport)

+ (BOOL)rzv_shouldAlwaysCreateNewObjectOnImport {
    return YES;
}

+ (NSArray *)rzi_ignoredKeys {
    return @[@"Points", @"TieBreaker", @"GoalsFor", @"GoalDifferential", @"Ties", @"GoalsAgainst"];
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"TeamName":RZDB_KP(STKEventStanding, teamName),
             @"Wins":RZDB_KP(STKEventStanding, wins),
             @"Losses":RZDB_KP(STKEventStanding, losses),
             @"SortOrder":RZDB_KP(STKEventStanding, sortOrder)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"TeamName"]) {
        NSString *pattern = @"([0-9]+)";
        NSString *seed = [value stk_stringMatchingRegexPattern:pattern];

        if (seed.length > 0) {
            self.seed = @(seed.integerValue);
        }
        else {
            self.seed = @(0);
        }
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
