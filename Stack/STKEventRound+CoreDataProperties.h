//
//  STKEventRound+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventRound.h"

@class STKEventCluster, STKEventBracket, STKEventPool;

NS_ASSUME_NONNULL_BEGIN

@interface STKEventRound (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *roundID;
@property (nullable, nonatomic, retain) NSSet<STKEventBracket *> *brackets;
@property (nullable, nonatomic, retain) STKEventGroup *group;
@property (nullable, nonatomic, retain) NSSet<STKEventPool *> *pools;
@property (nullable, nonatomic, retain) NSSet<STKEventCluster *> *clusters;

@end

@interface STKEventRound (CoreDataGeneratedAccessors)

- (void)addBracketsObject:(STKEventBracket *)value;
- (void)removeBracketsObject:(STKEventBracket *)value;
- (void)addBrackets:(NSSet<STKEventBracket *> *)values;
- (void)removeBrackets:(NSSet<STKEventBracket *> *)values;

- (void)addPoolsObject:(STKEventPool *)value;
- (void)removePoolsObject:(STKEventPool *)value;
- (void)addPools:(NSSet<STKEventPool *> *)values;
- (void)removePools:(NSSet<STKEventPool *> *)values;

- (void)addClustersObject:(STKEventCluster *)value;
- (void)removeClustersObject:(STKEventCluster *)value;
- (void)addClusters:(NSSet<STKEventCluster *> *)values;
- (void)removeClusters:(NSSet<STKEventCluster *> *)values;

@end

NS_ASSUME_NONNULL_END
