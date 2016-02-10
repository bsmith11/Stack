//
//  STKEvent.h
//  Stack
//
//  Created by Bradley Smith on 2/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "STKEventGroup.h"

@class RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKEvent : NSManagedObject

+ (NSFetchedResultsController *)fetchedResultsController;
+ (RZFetchedCollectionList *)fetchedListOfEvents;
+ (RZFetchedCollectionList *)fetchedListOfEventsWithGroupType:(STKEventGroupType)groupType groupDivision:(STKEventGroupDivision)groupDivision;
+ (void)downloadEventsWithCompletion:(void (^)(NSError *error))completion;
+ (void)downloadDetailsForEvent:(STKEvent *)event completion:(void (^)(NSError *error))completion;

- (STKEventGroup *)groupWithType:(STKEventGroupType)type division:(STKEventGroupDivision)division;

@end

NS_ASSUME_NONNULL_END

#import "STKEvent+CoreDataProperties.h"
#import "STKEvent+RZImport.h"
