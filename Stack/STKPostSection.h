//
//  STKPostSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKPost, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKPostSection : NSManagedObject

+ (RZFetchedCollectionList *)fetchedSectionsForPost:(STKPost *)post;

@end

NS_ASSUME_NONNULL_END

#import "STKPostSection+CoreDataProperties.h"
