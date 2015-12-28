//
//  STKTableViewDataSource.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKTableViewDataSource.h"

@interface STKTableViewDataSource () <ASTableViewDataSource>

@property (strong, nonatomic) NSMutableOrderedSet *mutableObjects;
@property (strong, nonatomic) NSOperationQueue *queue;

@property (copy, nonatomic) NSArray *sortDescriptors;

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
}

- (NSArray *)objects {
    return self.mutableObjects.array;
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

- (void)addObjects:(NSArray *)objects {
    if (objects.count > 0) {
        [self.queue addOperationWithBlock:^{
            NSMutableOrderedSet *newObjects = [NSMutableOrderedSet orderedSetWithArray:objects];
            [newObjects minusOrderedSet:self.mutableObjects];

            NSMutableOrderedSet *updatedObjects = [NSMutableOrderedSet orderedSetWithArray:objects];
            [updatedObjects intersectOrderedSet:self.mutableObjects];

            [self.mutableObjects unionOrderedSet:newObjects];
            [self.mutableObjects sortUsingDescriptors:self.sortDescriptors];

            NSIndexSet *newIndexes = [self.mutableObjects indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [newObjects containsObject:obj];
            }];

            NSIndexSet *updatedIndexes = [self.mutableObjects indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

            [self.tableView beginUpdates];

            [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationNone];

            [self.tableView endUpdatesAnimated:self.animateChanges completion:^(BOOL completed) {
                for (NSIndexPath *indexPath in updatedIndexPaths) {
                    if ([self tableView:self.tableView containsIndexPath:indexPath]) {
                        ASCellNode *node = [self.tableView nodeForRowAtIndexPath:indexPath];
                        id object = [self.mutableObjects objectAtIndex:(NSUInteger)indexPath.row];

                        if (node) {
                            [self.delegate tableView:self.tableView updateNode:node forObject:object atIndexPath:indexPath];
                        }
                    }
                }

                [self.delegate tableViewDidChangeContent:self.tableView];
            }];

        
        }];
    }
}

- (void)removeObjects:(NSArray *)objects {
    if (objects.count > 0) {
        [self.queue addOperationWithBlock:^{
            NSMutableOrderedSet *removedObjects = [NSMutableOrderedSet orderedSetWithArray:objects];

            [self.mutableObjects minusOrderedSet:removedObjects];
            [self.mutableObjects sortUsingDescriptors:self.sortDescriptors];

            NSIndexSet *removedIndexes = [self.mutableObjects indexesOfObjectsPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [removedObjects containsObject:obj];
            }];

            NSMutableArray *removedIndexPaths = [NSMutableArray array];
            [removedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [removedIndexPaths addObject:[NSIndexPath indexPathForRow:(NSInteger)idx inSection:0]];
            }];

            [self.tableView beginUpdates];

            [self.tableView deleteRowsAtIndexPaths:removedIndexPaths withRowAnimation:UITableViewRowAnimationNone];

            [self.tableView endUpdatesAnimated:self.animateChanges completion:^(BOOL completed) {
                [self.delegate tableViewDidChangeContent:self.tableView];
            }];
        }];
    }
}

- (void)replaceAllObjectsWithObjects:(NSArray *)objects {
    [self.queue addOperationWithBlock:^{
        [self.mutableObjects removeAllObjects];
        [self.mutableObjects addObjectsFromArray:objects];

        [self.tableView beginUpdates];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

        [self.tableView endUpdatesAnimated:self.animateChanges completion:^(BOOL completed) {
            [self.delegate tableViewDidChangeContent:self.tableView];
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
