//
//  STKEventGroup.m
//  Stack
//
//  Created by Bradley Smith on 2/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGroup.h"
#import "STKEvent.h"

#import <RZVinyl/RZVinyl.h>

@implementation STKEventGroup

+ (NSArray *)allEventGroups {
    return  [STKEventGroup rzv_all];
}

+ (NSString *)titleForType:(STKEventGroupType)type {
    return [self typeTitles][@(type)];
}

+ (NSDictionary *)typeTitles {
    static NSDictionary *typeTitles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeTitles = @{@(STKEventGroupTypeUnknown):@"Unknown",
                       @(STKEventGroupTypeCollege):@"College",
                       @(STKEventGroupTypeClub):@"Club",
                       @(STKEventGroupTypeMasters):@"Masters",
                       @(STKEventGroupTypeHighSchool):@"High School",
                       @(STKEventGroupTypeMiddleSchool):@"Middle School"};
    });

    return typeTitles;
}

+ (NSString *)titleForDivision:(STKEventGroupDivision)division {
    return [self divisionTitles][@(division)];
}

+ (NSDictionary *)divisionTitles {
    static NSDictionary *divisionTitles = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        divisionTitles = @{@(STKEventGroupDivisionUnknown):@"Unknown",
                           @(STKEventGroupDivisionMens):@"Mens",
                           @(STKEventGroupDivisionWomens):@"Womens",
                           @(STKEventGroupDivisionMixed):@"Mixed",
                           @(STKEventGroupDivisionBoys):@"Boys",
                           @(STKEventGroupDivisionGirls):@"Girls"};
    });

    return divisionTitles;
}

+ (NSArray *)divisionsForType:(STKEventGroupType)type {
    return [self validDivisions][@(type)];
}

+ (NSDictionary *)validDivisions {
    static NSDictionary *validDivisions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validDivisions = @{@(STKEventGroupTypeUnknown):[NSArray array],
                           @(STKEventGroupTypeCollege):@[@(STKEventGroupDivisionMens),
                                                         @(STKEventGroupDivisionWomens)],
                           @(STKEventGroupTypeClub):@[@(STKEventGroupDivisionMens),
                                                      @(STKEventGroupDivisionWomens),
                                                      @(STKEventGroupDivisionMixed)],
                           @(STKEventGroupTypeMasters):@[@(STKEventGroupDivisionMens),
                                                         @(STKEventGroupDivisionWomens)],
                           @(STKEventGroupTypeHighSchool):@[@(STKEventGroupDivisionBoys),
                                                            @(STKEventGroupDivisionGirls)],
                           @(STKEventGroupTypeMiddleSchool):@[@(STKEventGroupDivisionBoys),
                                                              @(STKEventGroupDivisionGirls)]};
    });

    return validDivisions;
}

@end
