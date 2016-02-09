//
//  STKEvent+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEvent+RZImport.h"

#import "STKEventGroup.h"

#import "STKFormatter.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEvent (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return @"EventId";
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKEvent, eventID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"EventId":RZDB_KP(STKEvent, eventID),
             @"EventLogo":RZDB_KP(STKEvent, logo),
             @"EventName":RZDB_KP(STKEvent, name),
             @"EventType":RZDB_KP(STKEvent, type),
             @"EventTypeName":RZDB_KP(STKEvent, typeName),
             @"City":RZDB_KP(STKEvent, city),
             @"State":RZDB_KP(STKEvent, state)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"CompetitionGroup"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *groups = [NSSet setWithArray:[STKEventGroup rzi_objectsFromArray:value inContext:context]];
            self.groups = groups;
        }
        else {
            for (STKEventGroup *group in self.groups) {
                [context deleteObject:group];
            }
        }

        return NO;
    }
    else if ([key isEqualToString:@"StartDate"]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.startDate = [[STKFormatter eventDateFormatter] dateFromString:value];
        }
        else {
            self.startDate = nil;
        }

        return NO;
    }
    else if ([key isEqualToString:@"EndDate"]) {
        if ([value isKindOfClass:[NSString class]]) {
            self.endDate = [[STKFormatter eventDateFormatter] dateFromString:value];
        }
        else {
            self.endDate = nil;
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
