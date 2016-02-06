//
//  STKEventGame.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGame.h"

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

@end
