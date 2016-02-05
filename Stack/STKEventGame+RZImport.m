//
//  STKEventGame+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGame+RZImport.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventGame (RZImport)

+ (BOOL)rzv_shouldAlwaysCreateNewObjectOnImport {
    return YES;
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"StartDate":RZDB_KP(STKEventGame, startDate),
             @"HomeTeamName":RZDB_KP(STKEventGame, homeTeamName),
             @"HomeTeamScore":RZDB_KP(STKEventGame, homeTeamScore),
             @"AwayTeamName":RZDB_KP(STKEventGame, awayTeamName),
             @"AwayTeamScore":RZDB_KP(STKEventGame, awayTeamScore),
             @"GameStatus":RZDB_KP(STKEventGame, status),
             @"FieldName":RZDB_KP(STKEventGame, fieldName)};
}

@end
