//
//  STKEventStanding+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventStanding+RZImport.h"

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

@end
