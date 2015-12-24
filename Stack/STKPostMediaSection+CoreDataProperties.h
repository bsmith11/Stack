//
//  STKPostMediaSection+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKPostMediaSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKPostMediaSection (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sourceURL;
@property (nullable, nonatomic, retain) NSString *linkURL;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSNumber *width;

@end

NS_ASSUME_NONNULL_END
