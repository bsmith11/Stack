//
//  STKEventStanding.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventStanding.h"
#import "STKEventPool.h"
#import "STKEventGroup.h"

#import "STKCoreDataStack.h"

#import <RZVinyl/RZVinyl.h>
#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventStanding

+ (RZFetchedCollectionList *)fetchedListOfStandingsForGroup:(STKEventGroup *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *poolNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pool.name" ascending:YES];
    NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventStanding, sortOrder) ascending:YES];
    NSSortDescriptor *seedSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventStanding, seed) ascending:YES];
    request.sortDescriptors = @[poolNameSortDescriptor, orderSortDescriptor, seedSortDescriptor];

    NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"pool.round.group", group];
    request.predicate = groupPredicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:@"pool.name"
                                                                                       cacheName:nil];
    return fetchedList;
}

@end
