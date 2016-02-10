//
//  STKSourceListViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSourceListViewModel.h"

#import "STKTableViewDataSource.h"

@interface STKSourceListViewModel ()

@property (strong, nonatomic, readwrite) NSArray *objects;
@property (strong, nonatomic) STKTableViewDataSource *dataSource;

@property (assign, nonatomic, readwrite) STKSourceType sourceType;

@end

@implementation STKSourceListViewModel

#pragma mark - Lifecycle

- (instancetype)initWithSourceListType:(STKSourceListType)sourceListType {
    self = [super init];

    if (self) {
        self.sourceType = -1;

        [self setupSourcesWithSourceListType:sourceListType];
    }

    return self;
}

#pragma mark - Setup

- (void)setupSourcesWithSourceListType:(STKSourceListType)sourceListType {
    NSArray *stackSourceType = @[@(-1)];
    NSArray *sourceTypes;

    switch (sourceListType) {
        case STKSourceListTypeAll:
            sourceTypes = [STKSource allSourceTypes];
            break;

        case STKSourceListTypeSearchAvailable:
            sourceTypes = [STKSource sourcesWithSearchAvailable];
            break;

        case STKSourceListTypeNotificationsAvailable:
            sourceTypes = [STKSource sourcesWithNotificationsAvailable];
            break;

        default:
            sourceTypes = [NSArray array];
            break;
    }

    self.objects = [stackSourceType arrayByAddingObjectsFromArray:sourceTypes];
}

- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[STKTableViewDataSource alloc] initWithTableView:tableView
                                                                objects:self.objects
                                                        sortDescriptors:nil
                                                               delegate:delegate];
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.objects objectAtIndex:(NSUInteger)indexPath.row];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(NSInteger)[self.objects indexOfObject:object] inSection:0];

    return indexPath;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *oldSourceTypeNumber = @(self.sourceType);
    NSIndexPath *oldIndexPath = [self indexPathForObject:oldSourceTypeNumber];
    ASCellNode *oldNode = [self.dataSource.tableView nodeForRowAtIndexPath:oldIndexPath];

    NSNumber *sourceTypeNumber = [self objectAtIndexPath:indexPath];
    ASCellNode *node = [self.dataSource.tableView nodeForRowAtIndexPath:indexPath];

    STKSourceType sourceType = sourceTypeNumber.integerValue;
    self.sourceType = sourceType;

    [self.dataSource.delegate tableView:self.dataSource.tableView updateNode:oldNode forObject:oldSourceTypeNumber atIndexPath:oldIndexPath];
    [self.dataSource.delegate tableView:self.dataSource.tableView updateNode:node forObject:sourceTypeNumber atIndexPath:indexPath];
}

@end
