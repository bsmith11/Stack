//
//  STKEventStage+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventStage.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKEventStage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *stageID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<STKEventGame *> *games;
@property (nullable, nonatomic, retain) STKEventBracket *bracket;

@end

@interface STKEventStage (CoreDataGeneratedAccessors)

- (void)addGamesObject:(STKEventGame *)value;
- (void)removeGamesObject:(STKEventGame *)value;
- (void)addGames:(NSSet<STKEventGame *> *)values;
- (void)removeGames:(NSSet<STKEventGame *> *)values;

@end

NS_ASSUME_NONNULL_END
