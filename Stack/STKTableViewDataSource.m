//
//  STKTableViewDataSource.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import CoreData;

#import "STKTableViewDataSource.h"

@interface STKTableViewDataSource () <ASTableViewDataSource>

@property (strong, nonatomic) NSMutableOrderedSet *mutableObjects;
@property (strong, nonatomic) NSOperationQueue *queue;

@property (copy, nonatomic) NSArray *sortDescriptors;
@property (copy, nonatomic) NSString *entityName;

@property (weak, nonatomic, readwrite) ASTableView *tableView;
@property (weak, nonatomic, readwrite) id <STKTableViewDataSourceDelegate> delegate;

@end

@implementation STKTableViewDataSource

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(ASTableView *)tableView
                          objects:(NSArray *)objects
                  sortDescriptors:(NSArray *)sortDescriptors
                         delegate:(id<STKTableViewDataSourceDelegate>)delegate {
    self = [super init];

    if (self) {
        self.animateChanges = YES;

        self.queue = [NSOperationQueue mainQueue];
        self.queue.maxConcurrentOperationCount = 1;

        self.tableView = tableView;
        tableView.asyncDataSource = nil;
        tableView.asyncDataSource = self;

        self.mutableObjects = [NSMutableOrderedSet orderedSetWithArray:objects];
        self.sortDescriptors = sortDescriptors;
        [self.mutableObjects sortUsingDescriptors:sortDescriptors];

        self.delegate = delegate;
    }

    return self;
}

- (void)dealloc {
    [self.queue cancelAllOperations];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)objects {
    return self.mutableObjects.array;
}

#pragma mark - Actions

- (void)registerForChangeNotificationsForContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeNSManagedObjectContext:) name:NSManagedObjectContextObjectsDidChangeNotification object:context];
    self.entityName = entityName;
}

- (void)unregisterForChangeNotificationsForContext:(NSManagedObjectContext *)context {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:context];
}

- (void)didChangeNSManagedObjectContext:(NSNotification *)notification {
    NSSet *deletedObjects = notification.userInfo[NSDeletedObjectsKey];

    if (self.entityName.length > 0) {
        NSManagedObjectContext *context = notification.object;
        NSDictionary *entitiesByName = context.persistentStoreCoordinator.managedObjectModel.entitiesByName;
        NSEntityDescription *entity = entitiesByName[self.entityName];

        if (entity) {
            NSSet *deletedEntities = [deletedObjects objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSManagedObject class]]) {
                    return [[obj entity] isKindOfEntity:entity];
                }
                else {
                    return NO;
                }
            }];

            if (deletedEntities.count > 0) {
                [self removeObjects:deletedEntities.allObjects completion:nil];
            }
        }
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.mutableObjects.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.mutableObjects objectAtIndex:(NSUInteger)indexPath.row];

    return [self.delegate tableView:tableView nodeForObject:object atIndexPath:indexPath];
}

- (void)tableViewLockDataSource:(ASTableView *)tableView {
    self.queue.suspended = YES;
}

- (void)tableViewUnlockDataSource:(ASTableView *)tableView {
    self.queue.suspended = NO;
}

- (void)addObjects:(NSArray *)objects completion:(void (^)(NSArray *))completion {
    if (objects.count > 0) {
        __weak __typeof(self) wself = self;

        [self.queue addOperationWithBlock:^{
            NSMutableOrderedSet *newObjects = [NSMutableOrderedSet orderedSetWithArray:objects];
            [newObjects minusOrderedSet:wself.mutableObjects];

            NSMutableOrderedSet *updatedObjects = [NSMutableOrderedSet orderedSetWithArray:objects];
            [updatedObjects intersectOrderedSet:wself.mutableObjects];

            [wself.mutableObjects unionOrderedSet:newObjects];
            [wself.mutableObjects sortUsingDescriptors:wself.sortDescriptors];

            NSIndexSet *newIndexes = [wself.mutableObjects indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [newObjects containsObject:obj];
            }];

            NSIndexSet *updatedIndexes = [wself.mutableObjects indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [updatedObjects containsObject:obj];
            }];

            NSMutableArray *newIndexPaths = [NSMutableArray array];
            [newIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [newIndexPaths addObject:[NSIndexPath indexPathForRow:(NSInteger)idx inSection:0]];
            }];

            NSMutableArray *updatedIndexPaths = [NSMutableArray array];
            [updatedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [updatedIndexPaths addObject:[NSIndexPath indexPathForRow:(NSInteger)idx inSection:0]];
            }];

            [wself.tableView beginUpdates];

            [wself.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationNone];

            [wself.tableView endUpdatesAnimated:wself.animateChanges completion:^(BOOL completed) {
                for (NSIndexPath *indexPath in updatedIndexPaths) {
                    if ([wself tableView:wself.tableView containsIndexPath:indexPath]) {
                        ASCellNode *node = [wself.tableView nodeForRowAtIndexPath:indexPath];
                        id object = [wself.mutableObjects objectAtIndex:(NSUInteger)indexPath.row];

                        if (node) {
                            [wself.delegate tableView:wself.tableView updateNode:node forObject:object atIndexPath:indexPath];
                        }
                    }
                }
                
                [wself.delegate tableViewDidChangeContent:wself.tableView];

                if (completion) {
                    completion(newIndexPaths);
                }
            }];
        }];
    }
    else {
        [self.queue addOperationWithBlock:^{
            if (completion) {
                completion(nil);
            }
        }];
    }
}

- (void)removeObjects:(NSArray *)objects completion:(void (^)(NSArray *))completion {
    if (objects.count > 0) {
        __weak __typeof(self) wself = self;

        [self.queue addOperationWithBlock:^{
            NSMutableOrderedSet *removedObjects = [NSMutableOrderedSet orderedSetWithArray:objects];

            NSIndexSet *removedIndexes = [self.mutableObjects indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [removedObjects containsObject:obj];
            }];

            NSMutableArray *removedIndexPaths = [NSMutableArray array];
            [removedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [removedIndexPaths addObject:[NSIndexPath indexPathForRow:(NSInteger)idx inSection:0]];
            }];

            [wself.mutableObjects minusOrderedSet:removedObjects];
            [wself.mutableObjects sortUsingDescriptors:wself.sortDescriptors];

            [wself.tableView beginUpdates];

            [wself.tableView deleteRowsAtIndexPaths:removedIndexPaths withRowAnimation:UITableViewRowAnimationNone];

            [wself.tableView endUpdatesAnimated:wself.animateChanges completion:^(BOOL completed) {
                [wself.delegate tableViewDidChangeContent:wself.tableView];

                if (completion) {
                    completion([removedIndexPaths copy]);
                }
            }];
        }];
    }
    else {
        [self.queue addOperationWithBlock:^{
            if (completion) {
                completion(nil);
            }
        }];
    }
}

- (void)replaceAllObjectsWithObjects:(NSArray *)objects completion:(void (^)())completion {
    __weak __typeof(self) wself = self;

    [self.queue addOperationWithBlock:^{
        [wself.mutableObjects removeAllObjects];
        [wself.mutableObjects addObjectsFromArray:objects];

        [wself.tableView beginUpdates];

        [wself.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

        [wself.tableView endUpdatesAnimated:wself.animateChanges completion:^(BOOL completed) {
            [wself.delegate tableViewDidChangeContent:wself.tableView];

            if (completion) {
                completion();
            }
        }];
    }];
}

#pragma mark - Helpers

- (BOOL)tableView:(ASTableView *)tableView containsIndexPath:(NSIndexPath *)indexPath {
    BOOL containsIndexPath = NO;
    
    if (indexPath.section < tableView.numberOfSections &&
        indexPath.row < [tableView numberOfRowsInSection:indexPath.section]) {
        containsIndexPath = YES;
    }
    
    return containsIndexPath;
}

@end
