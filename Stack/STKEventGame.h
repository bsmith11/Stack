//
//  STKEventGame.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKEventPool, STKEventCluster, STKEventGroup, STKEventBracket, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKEventGame : NSManagedObject

+ (RZFetchedCollectionList *)fetchedListOfGamesForPool:(STKEventPool *)pool;
+ (RZFetchedCollectionList *)fetchedListOfGamesForCluster:(STKEventCluster *)cluster;
+ (RZFetchedCollectionList *)fetchedListOfGamesForBracket:(STKEventBracket *)bracket;
+ (RZFetchedCollectionList *)fetchedListOfClusterGamesForGroup:(STKEventGroup *)group;

@end

NS_ASSUME_NONNULL_END

#import "STKEventGame+CoreDataProperties.h"
#import "STKEventGame+RZImport.h"
