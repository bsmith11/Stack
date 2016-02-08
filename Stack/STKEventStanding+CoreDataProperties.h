//
//  STKEventStanding+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventStanding.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKEventStanding (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *losses;
@property (nullable, nonatomic, retain) NSNumber *sortOrder;
@property (nullable, nonatomic, retain) NSString *teamName;
@property (nullable, nonatomic, retain) NSNumber *wins;
@property (nullable, nonatomic, retain) NSNumber *seed;
@property (nullable, nonatomic, retain) STKEventPool *pool;

@end

NS_ASSUME_NONNULL_END
