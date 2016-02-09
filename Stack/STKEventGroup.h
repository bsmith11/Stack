//
//  STKEventGroup.h
//  Stack
//
//  Created by Bradley Smith on 2/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKEvent, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, STKEventGroupType) {
    STKEventGroupTypeUnknown,
    STKEventGroupTypeClub,
    STKEventGroupTypeCollege,
    STKEventGroupTypeMasters,
    STKEventGroupTypeHighSchool,
    STKEventGroupTypeMiddleSchool
};

typedef NS_ENUM(NSInteger, STKEventGroupDivision) {
    STKEventGroupDivisionUnknown,
    STKEventGroupDivisionMens,
    STKEventGroupDivisionWomens,
    STKEventGroupDivisionMixed,
    STKEventGroupDivisionBoys,
    STKEventGroupDivisionGirls
};

@interface STKEventGroup : NSManagedObject

+ (RZFetchedCollectionList *)fetchedListOfGroupsForEvent:(STKEvent *)event;

+ (NSString *)titleForType:(STKEventGroupType)type;
+ (NSString *)titleForDivision:(STKEventGroupDivision)division;
+ (NSArray *)divisionsForType:(STKEventGroupType)type;

@end

NS_ASSUME_NONNULL_END

#import "STKEventGroup+CoreDataProperties.h"
#import "STKEventGroup+RZImport.h"
