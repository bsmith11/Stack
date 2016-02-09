//
//  STKEventCrossoversViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventCrossoversViewModel.h"

#import "STKEventGame.h"
#import "STKEventCluster.h"
#import "STKEventGroup.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventCrossoversViewModel ()

@property (strong, nonatomic) STKEventGroup *group;
@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZFetchedCollectionList *games;

@end

@implementation STKEventCrossoversViewModel

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.group = group;

        [self setupGames];
    }

    return self;
}

#pragma mark - Setup

- (void)setupGames {
    self.games = [STKEventGame fetchedListOfClusterGamesForGroup:self.group];
}

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.games delegate:delegate];
    self.dataSource.animateTableChanges = NO;
}

#pragma mark - Actions

- (STKEventGame *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.collectionList objectAtIndexPath:indexPath];
}

- (NSDate *)dateForSection:(NSInteger)section {
    STKEventGame *game = [self.games.sections[(NSUInteger)section] objects].firstObject;

    return game.startDateFull;
}

@end
