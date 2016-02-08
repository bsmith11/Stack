//
//  STKEventBracketsListViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracketsListViewModel.h"

#import "STKEventGroup.h"
#import "STKEventBracket.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKEventBracketsListViewModel ()

@property (strong, nonatomic) STKEventGroup *group;
@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZFetchedCollectionList *brackets;

@end

@implementation STKEventBracketsListViewModel

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.group = group;

        [self setupBrackets];
    }

    return self;
}

#pragma mark - Setup

- (void)setupBrackets {
    self.brackets = [STKEventBracket fetchedListOfBracketsForGroup:self.group];
}

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.brackets delegate:delegate];
    self.dataSource.animateTableChanges = NO;
}

#pragma mark - Actions

- (STKEventBracket *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.collectionList objectAtIndexPath:indexPath];
}

@end
