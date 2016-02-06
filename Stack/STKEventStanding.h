//
//  STKEventStanding.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKEventPool, STKEventGroup, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKEventStanding : NSManagedObject

+ (RZFetchedCollectionList *)fetchedListOfStandingsForGroup:(STKEventGroup *)group;

@end

NS_ASSUME_NONNULL_END

#import "STKEventStanding+CoreDataProperties.h"
#import "STKEventStanding+RZImport.h"
