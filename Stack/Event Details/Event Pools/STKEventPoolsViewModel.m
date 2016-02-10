//
//  STKEventPoolsViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPoolsViewModel.h"

#import "STKEvent.h"
#import "STKEventGroup.h"
#import "STKEventRound.h"
#import "STKEventPool.h"
#import "STKEventStanding.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventPoolsViewModel ()

@property (strong, nonatomic) STKEventGroup *group;
@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZFetchedCollectionList *standings;

@end

@implementation STKEventPoolsViewModel

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.group = group;

        [self setupStandings];
    }

    return self;
}

#pragma mark - Setup

- (void)setupStandings {
    self.standings = [STKEventStanding fetchedListOfStandingsForGroup:self.group];
}

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.standings delegate:delegate];
    self.dataSource.animateTableChanges = NO;
}

#pragma mark - Actions

- (STKEventStanding *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.collectionList objectAtIndexPath:indexPath];
}

- (STKEventPool *)poolForSection:(NSInteger)section {
    STKEventStanding *standing = [self.standings.sections[(NSUInteger)section] objects].firstObject;

    return standing.pool;
}

@end
