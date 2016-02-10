//
//  STKEventGroup+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventGroup.h"

@class STKEventRound;

NS_ASSUME_NONNULL_BEGIN

@interface STKEventGroup (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *eventGroupID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *divisionName;
@property (nullable, nonatomic, retain) NSString *teamCount;
@property (nullable, nonatomic, retain) NSNumber *division;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) STKEvent *event;
@property (nullable, nonatomic, retain) NSSet<STKEventRound *> *rounds;

@end

@interface STKEventGroup (CoreDataGeneratedAccessors)

- (void)addRoundsObject:(STKEventRound *)value;
- (void)removeRoundsObject:(STKEventRound *)value;
- (void)addRounds:(NSSet<STKEventRound *> *)values;
- (void)removeRounds:(NSSet<STKEventRound *> *)values;

@end

NS_ASSUME_NONNULL_END
