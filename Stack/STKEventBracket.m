//
//  STKEventBracket.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracket.h"
#import "STKEventRound.h"
#import "STKEventGroup.h"

#import "STKCoreDataStack.h"

#import <RZVinyl/RZVinyl.h>
#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventBracket

+ (RZFetchedCollectionList *)fetchedListOfBracketsForGroup:(STKEventGroup *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *roundSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"round.roundID" ascending:YES];
    NSSortDescriptor *sortOrderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventBracket, sortOrder) ascending:YES];
    request.sortDescriptors = @[roundSortDescriptor, sortOrderSortDescriptor];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"round.group", group];
    request.predicate = predicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    return fetchedList;
}

@end
