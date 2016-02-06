//
//  STKEventGroup+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGroup+RZImport.h"
#import "STKEventRound.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventGroup (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return @"EventGroupId";
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKEventGroup, eventGroupID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"EventGroupId":RZDB_KP(STKEventGroup, eventGroupID),
             @"EventGroupName":RZDB_KP(STKEventGroup, name),
             @"GroupName":RZDB_KP(STKEventGroup, name),
             @"DivisionName":RZDB_KP(STKEventGroup, divisionName),
             @"TeamCount":RZDB_KP(STKEventGroup, teamCount)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"GroupName"]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.type = @([STKEventGroup typeFromString:value]);
            self.division = @([STKEventGroup divisionFromString:value]);
        }
        else {
            self.type = @(STKEventGroupTypeUnknown);
            self.division = @(STKEventGroupDivisionUnknown);
        }
    }
    else if ([key isEqualToString:@"EventRounds"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *rounds = [NSSet setWithArray:[STKEventRound rzi_objectsFromArray:value inContext:context]];
            self.rounds = rounds;
        }
        else {
            for (STKEventRound *round in self.rounds) {
                [context deleteObject:round];
            }
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

+ (STKEventGroupType)typeFromString:(NSString *)string {
    STKEventGroupType type = STKEventGroupTypeUnknown;
    NSArray *components = [string componentsSeparatedByString:@"-"];

    if (components.count > 1) {
        NSString *trimmedString = [components.firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if ([trimmedString isEqualToString:@"Club"]) {
            type = STKEventGroupTypeClub;
        }
        else if ([trimmedString isEqualToString:@"College"]) {
            type = STKEventGroupTypeCollege;
        }
        else if ([trimmedString isEqualToString:@"High School"]) {
            type = STKEventGroupTypeHighSchool;
        }
        else if ([trimmedString isEqualToString:@"Middle School"]) {
            type = STKEventGroupTypeMiddleSchool;
        }
        else if ([trimmedString isEqualToString:@"Masters"]) {
            type = STKEventGroupTypeMasters;
        }
    }

    return type;
}

+ (STKEventGroupDivision)divisionFromString:(NSString *)string {
    STKEventGroupDivision division = STKEventGroupDivisionUnknown;
    NSArray *components = [string componentsSeparatedByString:@"-"];

    if (components.count > 1) {
        NSString *trimmedString = [components.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"'s" withString:@""];

        if ([trimmedString isEqualToString:@"Men"]) {
            division = STKEventGroupDivisionMens;
        }
        else if ([trimmedString isEqualToString:@"Women"]) {
            division = STKEventGroupDivisionWomens;
        }
        else if ([trimmedString isEqualToString:@"Mixed"]) {
            division = STKEventGroupDivisionMixed;
        }
        else if ([trimmedString isEqualToString:@"Boys"]) {
            division = STKEventGroupDivisionBoys;
        }
        else if ([trimmedString isEqualToString:@"Girls"]) {
            division = STKEventGroupDivisionGirls;
        }
    }

    return division;
}

@end
