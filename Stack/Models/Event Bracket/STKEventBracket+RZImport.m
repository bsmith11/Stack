//
//  STKEventBracket+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracket+RZImport.h"

#import "STKEventStage.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventBracket (RZImport)

+ (NSString *)rzv_externalPrimaryKey {
    return @"BracketId";
}

+ (NSString *)rzv_primaryKey {
    return RZDB_KP(STKEventBracket, bracketID);
}

+ (NSDictionary *)rzi_customMappings {
    return @{@"BracketId":RZDB_KP(STKEventBracket, bracketID),
             @"BracketName":RZDB_KP(STKEventBracket, name)};
}

- (BOOL)rzi_shouldImportValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    if ([key isEqualToString:@"Stage"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSSet *stages = [NSSet setWithArray:[STKEventStage rzi_objectsFromArray:value inContext:context]];

            self.stages = stages;
        }
        else {
            for (STKEventStage *stage in self.stages) {
                [context deleteObject:stage];
            }
        }

        return NO;
    }

    return [super rzi_shouldImportValue:value forKey:key inContext:context];
}

@end
