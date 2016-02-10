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

+ (void)fetchEventsWithCompletion:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completion {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, startDate) ascending:NO];
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, name) ascending:YES];
    request.sortDescriptors = @[dateSortDescriptor, nameSortDescriptor];

    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEvent, type), @"Tournament"];
    request.predicate = typePredicate;

    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request
                                                                                        completionBlock:completion];
    NSManagedObjectContext *context = [STKCoreDataStack defaultStack].mainManagedObjectContext;

    [context performBlock:^{
        [context executeRequest:asyncRequest error:nil];
    }];
}

+ (NSFetchedResultsController *)fetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self rzv_entityName]];

    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, startDate) ascending:NO];
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:RZDB_KP(STKEvent, name) ascending:YES];
    request.sortDescriptors = @[dateSortDescriptor, nameSortDescriptor];

    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEvent, type), @"Tournament"];
    request.predicate = typePredicate;

    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:[STKCoreDataStack defaultStack].mainManagedObjectContext
                                                                              sectionNameKeyPath:RZDB_KP(STKEvent, startDate)
                                                                                       cacheName:nil];
    return frc;
}

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

//    NSDictionary *responseObject = [self mockEventResponseObject];
//    [[STKCoreDataStack defaultStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
//        [STKEvent rzi_objectsFromArray:responseObject[@"Events"] inContext:context];
//    } completion:completion];
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

//    NSDictionary *responseObject = [self mockEventDetailsResponseObject];
//    [[STKCoreDataStack defaultStack] performBlockUsingBackgroundContext:^(NSManagedObjectContext *context) {
//        [STKEventGroup rzi_objectsFromArray:responseObject[@"EventGroups"] inContext:context];
//    } completion:completion];
}

+ (NSDictionary *)mockEventResponseObject {
    NSDictionary *event = @{@"EventId": @2707,
                            @"EventLogo": @"assets\\7\\MaineUltimate.jpg",
                            @"EventName": @"The Lobster Pot Tournament",
                            @"EventType": @"Tournament",
                            @"EventTypeName": @"Sanctioned Tournament",
                            @"City": @"South Portland",
                            @"State": @"ME",
                            @"CompetitionGroup": @[@{@"EventGroupId": @3358,
                                                     @"GroupName": @"College - Women ",
                                                     @"DivisionName": @"",
                                                     @"TeamCount": @"14"}],
                            @"StartDate": @"10/24/2015 6:00:00 AM",
                            @"EndDate": @"10/25/2015 6:00:00 AM"};

    NSDictionary *responseObject = @{@"Events":@[event]};

    return responseObject;
}

+ (NSDictionary *)mockEventDetailsResponseObject {
    NSArray *standings = @[[self standingWithName:@"Team 1" wins:@5 losses:@0 sortOrder:@1],
                           [self standingWithName:@"Team 2" wins:@4 losses:@1 sortOrder:@2],
                           [self standingWithName:@"Team 3" wins:@3 losses:@2 sortOrder:@3],
                           [self standingWithName:@"Team 4" wins:@2 losses:@3 sortOrder:@4],
                           [self standingWithName:@"Team 5" wins:@1 losses:@4 sortOrder:@5]];

    NSDictionary *eventPool = @{@"PoolId":@6609,
                                @"Name":@"Pool A",
                                @"Standings":standings};

    NSDictionary *eventRound = @{@"RoundId":@6257,
                                 @"Pools":@[eventPool]};

    NSDictionary *eventGroup = @{@"EventGroupId":@3358,
                                 @"EventGroupName":@"College - Women",
                                 @"EventRounds":@[eventRound]};

    NSDictionary *responseObject = @{@"success": @YES,
                                     @"EventGroups": @[eventGroup]};

    return responseObject;
}

- (STKEventGroup *)groupWithType:(STKEventGroupType)type division:(STKEventGroupDivision)division {
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEventGroup, type), @(type)];
    NSPredicate *divisionPredicate = [NSPredicate predicateWithFormat:@"%K == %@", RZDB_KP(STKEventGroup, division), @(division)];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[typePredicate, divisionPredicate]];

    STKEventGroup *group = (STKEventGroup *)[self.groups.allObjects filteredArrayUsingPredicate:predicate].firstObject;

    return group;
}

+ (NSDictionary *)standingWithName:(NSString *)name wins:(NSNumber *)wins losses:(NSNumber *)losses sortOrder:(NSNumber *)sortOrder {
    NSDictionary *standing = @{@"TeamName":name,
                               @"Wins":wins,
                               @"Losses":losses,
                               @"SortOrder":sortOrder};
    return standing;
}

@end
