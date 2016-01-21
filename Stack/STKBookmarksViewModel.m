//
//  STKBookmarksViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBookmarksViewModel.h"

#import "STKPost.h"

#import "STKTableViewDataSource.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKBookmarksViewModel () <RZCollectionListObserver>

@property (strong, nonatomic) RZFetchedCollectionList *posts;
@property (strong, nonatomic) STKTableViewDataSource *dataSource;
@property (strong, nonatomic) NSMutableArray *addedObjects;
@property (strong, nonatomic) NSMutableArray *removedObjects;

@end

@implementation STKBookmarksViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.addedObjects = [NSMutableArray array];
        self.removedObjects = [NSMutableArray array];

        [self setupPosts];
    }

    return self;
}

#pragma mark - Setup

- (void)setupPosts {
    self.posts = [STKPost fetchedListOfBookmarkedPosts];
    [self.posts addCollectionListObserver:self];
}

- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[STKTableViewDataSource alloc] initWithTableView:tableView
                                                                objects:[NSArray array]
                                                        sortDescriptors:@[[STKPost createDateSortDescriptor]]
                                                               delegate:delegate];

    self.dataSource.animateChanges = NO;

    [self.dataSource addObjects:self.posts.listObjects completion:nil];
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.posts objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return [self.posts indexPathForObject:object];
}

#pragma mark - Collection List Observer

- (void)collectionListWillChangeContent:(id<RZCollectionList>)collectionList {
    [self.addedObjects removeAllObjects];
    [self.removedObjects removeAllObjects];
}

- (void)collectionList:(id<RZCollectionList>)collectionList didChangeSection:(id<RZCollectionListSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(RZCollectionListChangeType)type {

}

- (void)collectionList:(id<RZCollectionList>)collectionList didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(RZCollectionListChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == RZCollectionListChangeInsert) {
        [self.addedObjects addObject:object];
    }
    else if (type == RZCollectionListChangeDelete) {
        [self.removedObjects addObject:object];
    }
}

- (void)collectionListDidChangeContent:(id<RZCollectionList>)collectionList {
    [self.dataSource addObjects:[self.addedObjects copy] completion:nil];
    [self.dataSource removeObjects:[self.removedObjects copy] completion:nil];
}

@end
