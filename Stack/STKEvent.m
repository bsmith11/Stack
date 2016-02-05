//
//  STKEvent.m
//  Stack
//
//  Created by Bradley Smith on 2/2/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEvent.h"
#import "STKEventGroup.h"

#import "STKAPIClient.h"
#import "STKCoreDataStack.h"

#import <RZCollectionList/RZFetchedCollectionList.h>
#import <RZDataBinding/RZDataBinding.h>

@implementation STKEvent

+ (RZFetchedCollectionList *)fetchedListOfEvents {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, startDate) ascending:NO];
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, name) ascending:YES];
    request.sortDescriptors = @[dateSortDescriptor, nameSortDescriptor];

    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEvent, type), @"Tournament"];
    request.predicate = typePredicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:RZDB_KP(STKEvent, startDate)
                                                                                       cacheName:nil];
    return fetchedList;
}

+ (RZFetchedCollectionList *)fetchedListOfEventsWithGroupType:(STKEventGroupType)groupType groupDivision:(STKEventGroupDivision)groupDivision {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, startDate) ascending:NO];
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, name) ascending:YES];
    request.sortDescriptors = @[dateSortDescriptor, nameSortDescriptor];

    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEvent, type), @"Tournament"];
    NSPredicate *groupTypePredicate = [NSPredicate predicateWithFormat:@"ANY groups.type == %@", @(groupType)];
    NSPredicate *groupDivisionPredicate = [NSPredicate predicateWithFormat:@"ANY groups.division == %@", @(groupDivision)];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[groupTypePredicate, groupDivisionPredicate, typePredicate]];

    request.predicate = predicate;

    RZFetchedCollectionList *fetchedList = [[RZFetchedCollectionList alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:RZDB_KP(STKEvent, startDate)
                                                                                       cacheName:nil];
    return fetchedList;
}

+ (void)downloadEventsWithCompletion:(void (^)(NSError *))completion {
    [[STKAPIClient sharedInstance] getEventsWithCompletion:^(id responseObject, NSError *error) {
        if (!error) {
            [[STKCoreDataStack defaultStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
                [STKEvent rzi_objectsFromArray:responseObject[@"Events"] inContext:context];
            } completion:completion];
        }
        else {
            if (completion) {
                completion(error);
            }
        }
    }];
}

+ (void)downloadDetailsForEvent:(STKEvent *)event completion:(void (^)(NSError * _Nonnull))completion {
    [[STKAPIClient sharedInstance] getEventWithID:event.eventID completion:^(id responseObject, NSError *error) {
        if (!error) {
            [[STKCoreDataStack defaultStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
                [STKEventGroup rzi_objectsFromArray:responseObject[@"EventGroups"] inContext:context];
            } completion:completion];
        }
        else {
            if (completion) {
                completion(error);
            }
        }
    }];
}

@end
