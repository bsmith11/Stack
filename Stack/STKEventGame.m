//
//  STKEventGame.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGame.h"
#import "STKEventBracket.h"
#import "STKEventCluster.h"
#import "STKEventPool.h"

#import "STKCoreDataStack.h"

#import <RZVinyl/RZVinyl.h>
#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventGame

+ (RZFetchedCollectionList *)fetchedListOfGamesForPool:(STKEventPool *)pool {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *startDateFullSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventGame, startDateFull) ascending:YES];
    request.sortDescriptors = @[startDateFullSortDescriptor];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEventGame, pool), pool];
    request.predicate = predicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:RZDB_KP(STKEventGame, startDateFull)
                                                                                       cacheName:nil];
    return fetchedList;
}

+ (RZFetchedCollectionList *)fetchedListOfGamesForCluster:(STKEventCluster *)cluster {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *startDateFullSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventGame, startDateFull) ascending:YES];
    request.sortDescriptors = @[startDateFullSortDescriptor];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEventGame, cluster), cluster];
    request.predicate = predicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:RZDB_KP(STKEventGame, startDateFull)
                                                                                       cacheName:nil];
    return fetchedList;
}

+ (RZFetchedCollectionList *)fetchedListOfGamesForBracket:(STKEventBracket *)bracket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *stageSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"stage.stageID" ascending:YES];
    NSSortDescriptor *sortOrderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventGame, sortOrder) ascending:YES];
    request.sortDescriptors = @[stageSortDescriptor, sortOrderSortDescriptor];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"stage.bracket", bracket];
    request.predicate = predicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:@"stage.stageID"
                                                                                       cacheName:nil];
    return fetchedList;
}

+ (RZFetchedCollectionList *)fetchedListOfClusterGamesForGroup:(STKEventGroup *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *startDateFullSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventGame, startDateFull) ascending:YES];
    request.sortDescriptors = @[startDateFullSortDescriptor];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"cluster.round.group", group];
    request.predicate = predicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:RZDB_KP(STKEventGame, startDateFull)
                                                                                       cacheName:nil];
    return fetchedList;
}

@end
