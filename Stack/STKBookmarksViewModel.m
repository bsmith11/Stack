//
//  STKBookmarksViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBookmarksViewModel.h"

#import "STKPost.h"

#import "STKCollectionListTableViewDataSource.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKBookmarksViewModel () <RZCollectionListObserver>

@property (strong, nonatomic) RZFetchedCollectionList *posts;
@property (strong, nonatomic, readwrite) UITabBarItem *tabBarItem;
@property (strong, nonatomic) STKCollectionListTableViewDataSource *dataSource;

@property (assign, nonatomic, readwrite) BOOL empty;

@end

@implementation STKBookmarksViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupPosts];
    }

    return self;
}

#pragma mark - Setup

- (void)setupPosts {
    self.posts = [STKPost fetchedListOfBookmarkedPosts];
    [self.posts addCollectionListObserver:self];
    [self collectionListDidChangeContent:self.posts];
}

- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKCollectionListTableViewDelegate>)delegate {
    self.dataSource = [[STKCollectionListTableViewDataSource alloc] initWithTableView:tableView
                                                                       collectionList:self.posts
                                                                             delegate:delegate];
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

}

- (void)collectionList:(id<RZCollectionList>)collectionList didChangeSection:(id<RZCollectionListSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(RZCollectionListChangeType)type {

}

- (void)collectionList:(id<RZCollectionList>)collectionList didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(RZCollectionListChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

}

- (void)collectionListDidChangeContent:(id<RZCollectionList>)collectionList {
    self.empty = (collectionList.listObjects.count == 0);
}

@end
