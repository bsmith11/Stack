//
//  STKComment+CoreDataProperties.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STKComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface STKComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *authorAvatarImageURL;
@property (nullable, nonatomic, retain) NSString *authorName;
@property (nullable, nonatomic, retain) NSString *commentID;
@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSData *content;
@property (nullable, nonatomic, retain) STKPost *post;

@end

NS_ASSUME_NONNULL_END
