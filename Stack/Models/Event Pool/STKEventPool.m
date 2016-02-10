//
//  STKEventPool.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPool.h"
#import "STKEventRound.h"
#import "STKEventGroup.h"

#import "STKCoreDataStack.h"

#import <RZVinyl/RZVinyl.h>
#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventPool

+ (RZFetchedCollectionList *)fetchedListOfPoolsForGroup:(STKEventGroup *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventPool, name) ascending:YES];
    request.sortDescriptors = @[nameSortDescriptor];

    NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"round.group", group];
    request.predicate = groupPredicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    return fetchedList;
}

@end
