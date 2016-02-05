//
//  STKEventGame+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKEventGame.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKEventGame (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSString *homeTeamName;
@property (nullable, nonatomic, retain) NSString *homeTeamScore;
@property (nullable, nonatomic, retain) NSString *awayTeamName;
@property (nullable, nonatomic, retain) NSString *awayTeamScore;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *fieldName;
@property (nullable, nonatomic, retain) STKEventPool *pool;

@end

NS_ASSUME_NONNULL_END
