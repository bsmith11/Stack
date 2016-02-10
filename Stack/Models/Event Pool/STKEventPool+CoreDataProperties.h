//
//  STKEventPool+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventPool.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKEventPool (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *poolID;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *games;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *standings;
@property (nullable, nonatomic, retain) STKEventRound *round;

@end

@interface STKEventPool (CoreDataGeneratedAccessors)

- (void)addGamesObject:(NSManagedObject *)value;
- (void)removeGamesObject:(NSManagedObject *)value;
- (void)addGames:(NSSet<NSManagedObject *> *)values;
- (void)removeGames:(NSSet<NSManagedObject *> *)values;

- (void)addStandingsObject:(NSManagedObject *)value;
- (void)removeStandingsObject:(NSManagedObject *)value;
- (void)addStandings:(NSSet<NSManagedObject *> *)values;
- (void)removeStandings:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
