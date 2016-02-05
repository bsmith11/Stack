//
//  STKEventBracket+RZImport.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracket+RZImport.h"

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

@end
