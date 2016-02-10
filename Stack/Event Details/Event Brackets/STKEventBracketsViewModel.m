//
//  STKEventBracketsViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracketsViewModel.h"

#import "STKEventBracket.h"
#import "STKEventStage.h"
#import "STKEventGame.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventBracketsViewModel ()

@property (strong, nonatomic) STKEventBracket *bracket;
@property (strong, nonatomic) RZCollectionListCollectionViewDataSource *dataSource;
@property (strong, nonatomic) RZFetchedCollectionList *games;

@end

@implementation STKEventBracketsViewModel

- (instancetype)initWithEventBracket:(STKEventBracket *)bracket {
    self = [super init];

    if (self) {
        self.bracket = bracket;

        [self setupGames];
    }

    return self;
}

#pragma mark - Setup

- (void)setupGames {
    self.games = [STKEventGame fetchedListOfGamesForBracket:self.bracket];
}

- (void)setupDataSourceWithCollectionView:(UICollectionView *)collectionView delegate:(id<RZCollectionListCollectionViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListCollectionViewDataSource alloc] initWithCollectionView:collectionView collectionList:self.games delegate:delegate];
    self.dataSource.animateCollectionChanges = NO;
}

#pragma mark - Actions

- (STKEventGame *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.collectionList objectAtIndexPath:indexPath];
}

- (STKEventStage *)stageForSection:(NSInteger)section {
    STKEventGame *game = [self.games.sections[(NSUInteger)section] objects].firstObject;

    return game.stage;
}

@end
