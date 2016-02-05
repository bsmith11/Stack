//
//  STKEventRound+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventRound.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKEventRound (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *roundID;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *pools;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *brackets;
@property (nullable, nonatomic, retain) STKEventGroup *group;

@end

@interface STKEventRound (CoreDataGeneratedAccessors)

- (void)addPoolsObject:(NSManagedObject *)value;
- (void)removePoolsObject:(NSManagedObject *)value;
- (void)addPools:(NSSet<NSManagedObject *> *)values;
- (void)removePools:(NSSet<NSManagedObject *> *)values;

- (void)addBracketsObject:(NSManagedObject *)value;
- (void)removeBracketsObject:(NSManagedObject *)value;
- (void)addBrackets:(NSSet<NSManagedObject *> *)values;
- (void)removeBrackets:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
