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

@interface STKBookmarksViewModel ()

@property (strong, nonatomic) RZFetchedCollectionList *posts;
@property (strong, nonatomic, readwrite) UITabBarItem *tabBarItem;
@property (strong, nonatomic) STKCollectionListTableViewDataSource *dataSource;

@end

@implementation STKBookmarksViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        UIImage *image = [UIImage imageNamed:@"Bookmark Off Icon"];
        UIImage *selectedImage = [UIImage imageNamed:@"Bookmark On Icon"];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Bookmarks" image:image selectedImage:selectedImage];

        [self setupPosts];
    }

    return self;
}

#pragma mark - Setup

- (void)setupPosts {
    self.posts = [STKPost fetchedListOfBookmarkedPosts];
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

@end
