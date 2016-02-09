//
//  STKEventGroupsListViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGroupsListViewModel.h"
#import "STKEventGroup.h"
#import "STKEvent.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventGroupsListViewModel ()

@property (strong, nonatomic) STKEvent *event;
@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZFetchedCollectionList *groups;

@end

@implementation STKEventGroupsListViewModel

#pragma mark - Lifecycle

- (instancetype)initWithEvent:(STKEvent *)event {
    self = [super init];

    if (self) {
        self.event = event;

        [self setupGroups];
    }

    return self;
}

#pragma mark - Setup

- (void)setupGroups {
    self.groups = [STKEventGroup fetchedListOfGroupsForEvent:self.event];
}

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.groups delegate:delegate];
    self.dataSource.animateTableChanges = NO;
}

#pragma mark - Actions

- (STKEventGroup *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.collectionList objectAtIndexPath:indexPath];
}

@end
