//
//  STKPost+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKPost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *postID;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSDate *modifyDate;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSNumber *bookmarked;
@property (nullable, nonatomic, retain) NSNumber *sourceType;
@property (nullable, nonatomic, retain) STKAttachment *attachment;
@property (nullable, nonatomic, retain) STKAuthor *author;
@property (nullable, nonatomic, retain) NSSet<STKComment *> *comments;
@property (nullable, nonatomic, retain) NSSet<STKPostSection *> *sections;

@end

@interface STKPost (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(STKComment *)value;
- (void)removeCommentsObject:(STKComment *)value;
- (void)addComments:(NSSet<STKComment *> *)values;
- (void)removeComments:(NSSet<STKComment *> *)values;

- (void)addSectionsObject:(STKPostSection *)value;
- (void)removeSectionsObject:(STKPostSection *)value;
- (void)addSections:(NSSet<STKPostSection *> *)values;
- (void)removeSections:(NSSet<STKPostSection *> *)values;

@end

NS_ASSUME_NONNULL_END
