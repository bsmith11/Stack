//
//  STKEventBracket+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventBracket.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKEventBracket (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *bracketID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) STKEventRound *round;

@end

NS_ASSUME_NONNULL_END
