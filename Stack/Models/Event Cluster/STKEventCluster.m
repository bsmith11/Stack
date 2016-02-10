//
//  STKEventCluster.m
//  Stack
//
//  Created by Bradley Smith on 2/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventCluster.h"
#import "STKEventGame.h"
#import "STKEventRound.h"

#import "STKCoreDataStack.h"

#import <RZVinyl/RZVinyl.h>
#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDBMacros.h>

@implementation STKEventCluster

+ (RZFetchedCollectionList *)fetchedListOfClustersForGroup:(STKEventGroup *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEventCluster, name) ascending:YES];
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
