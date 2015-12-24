//
//  STKSourceListViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSourceListViewModel.h"

#import "STKTableViewDataSource.h"
//#import "STKCollectionListTableViewDataSource.h"
//#import "STKSourceListObject.h"

#import <RZCollectionList/RZCollectionList.h>
#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDataBinding.h>

@interface STKSourceListViewModel ()

@property (strong, nonatomic, readwrite) NSArray *objects;
@property (strong, nonatomic) STKTableViewDataSource *dataSource;

@end

@implementation STKSourceListViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.sourceType = -1;

        [self setupSources];
    }

    return self;
}

#pragma mark - Setup

- (void)setupSources {
    NSArray *stackSourceType = @[@(-1)];
    NSArray *sourceTypes = [STKSource allSourceTypes];

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

@end
