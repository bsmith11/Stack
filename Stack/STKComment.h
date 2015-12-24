//
//  STKComment.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKPost, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKComment : NSManagedObject

+ (RZFetchedCollectionList *)fetchedListOfCommentsForPost:(STKPost *)post;
+ (void)downloadCommentsForPost:(STKPost *)post completion:(void (^ _Nullable)(NSError *error))completion;

- (NSAttributedString *)attributedContent;

@end

NS_ASSUME_NONNULL_END

#import "STKComment+CoreDataProperties.h"
