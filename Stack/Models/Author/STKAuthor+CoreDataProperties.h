//
//  STKAuthor+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKAuthor.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKAuthor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorID;
@property (nullable, nonatomic, retain) NSString *avatarImageURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSData *summary;
@property (nullable, nonatomic, retain) NSNumber *sourceType;
@property (nullable, nonatomic, retain) NSSet<STKPost *> *posts;

@end

@interface STKAuthor (CoreDataGeneratedAccessors)

- (void)addPostsObject:(STKPost *)value;
- (void)removePostsObject:(STKPost *)value;
- (void)addPosts:(NSSet<STKPost *> *)values;
- (void)removePosts:(NSSet<STKPost *> *)values;

@end

NS_ASSUME_NONNULL_END
