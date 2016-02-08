//
//  STKEventBracket.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STKEventRound, STKEventGroup, RZFetchedCollectionList;

NS_ASSUME_NONNULL_BEGIN

@interface STKEventBracket : NSManagedObject

+ (RZFetchedCollectionList *)fetchedListOfBracketsForGroup:(STKEventGroup *)group;

@end

NS_ASSUME_NONNULL_END

#import "STKEventBracket+CoreDataProperties.h"
#import "STKEventBracket+RZImport.h"
