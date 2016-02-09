//
//  STKEvent+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKEvent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *eventID;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *typeName;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *groups;

@end

@interface STKEvent (CoreDataGeneratedAccessors)

- (void)addGroupsObject:(NSManagedObject *)value;
- (void)removeGroupsObject:(NSManagedObject *)value;
- (void)addGroups:(NSSet<NSManagedObject *> *)values;
- (void)removeGroups:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
