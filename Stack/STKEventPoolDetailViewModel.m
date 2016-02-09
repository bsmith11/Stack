//
//  STKEventPoolDetailViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPoolDetailViewModel.h"

#import "STKEventPool.h"
#import "STKEventGame.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventPoolDetailViewModel ()

@property (strong, nonatomic) STKEventPool *pool;
@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZFetchedCollectionList *games;

@end

@implementation STKEventPoolDetailViewModel

#pragma mark - Lifecycle

- (instancetype)initWithEventPool:(STKEventPool *)pool {
    self = [super init];

    if (self) {
        self.pool = pool;

        [self setupGames];
    }

    return self;
}

#pragma mark - Setup

- (void)setupGames {
    self.games = [STKEventGame fetchedListOfGamesForPool:self.pool];
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
