//
//  STKEventPool.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKEventRound, STKEventGroup, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKEventPool : NSManagedObject

+ (RZFetchedCollectionList *)fetchedListOfPoolsForGroup:(STKEventGroup *)group;

@end

NS_ASSUME_NONNULL_END

#import "STKEventPool+CoreDataProperties.h"
#import "STKEventPool+RZImport.h"
