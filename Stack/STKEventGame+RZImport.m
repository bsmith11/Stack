//
//  STKEventGame+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGame+RZImport.h"

#import "STKFormatter.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventGame (RZImport)

+ (BOOL)rzv_shouldAlwaysCreateNewObjectOnImport {
    return YES;
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"HomeTeamName":RZDB_KP(STKEventGame, homeTeamName),
             @"HomeTeamScore":RZDB_KP(STKEventGame, homeTeamScore),
             @"AwayTeamName":RZDB_KP(STKEventGame, awayTeamName),
             @"AwayTeamScore":RZDB_KP(STKEventGame, awayTeamScore),
             @"GameStatus":RZDB_KP(STKEventGame, status),
             @"FieldName":RZDB_KP(STKEventGame, fieldName)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"StartDate"]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.startDate = [[STKFormatter gameDateDateFormatter] dateFromString:value];
        }
        else {
            self.startDate = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:@"StartTime"]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.startTime = [[STKFormatter gameTimeDateFormatter] dateFromString:value];
        }
        else {
            self.startTime = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
