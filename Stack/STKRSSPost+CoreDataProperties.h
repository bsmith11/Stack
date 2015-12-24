//
//  STKRSSPost+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKRSSPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKRSSPost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *commentsRSS;

@end

NS_ASSUME_NONNULL_END
