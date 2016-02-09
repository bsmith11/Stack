//
//  STKEventCluster.h
//  Stack
//
//  Created by Bradley Smith on 2/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKEventGame, STKEventRound, STKEventGroup, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKEventCluster : NSManagedObject

+ (RZFetchedCollectionList *)fetchedListOfClustersForGroup:(STKEventGroup *)group;

@end

NS_ASSUME_NONNULL_END

#import "STKEventCluster+CoreDataProperties.h"
#import "STKEventCluster+RZImport.h"
