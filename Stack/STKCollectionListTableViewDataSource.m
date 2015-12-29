//
//  STKCollectionListTableViewDataSource.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKCollectionListTableViewDataSource.h"

@interface STKCollectionListTableViewDataSource () <RZCollectionListDelegate, RZCollectionListObserver>

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@property (weak, nonatomic, readwrite) ASTableView *tableView;

@end

@implementation STKCollectionListTableViewDataSource

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(ASTableView *)tableView collectionList:(id<RZCollectionList>)collectionList delegate:(id<STKCollectionListTableViewDelegate>)delegate {
    NSParameterAssert(tableView);

    self = [super init];

    if (self) {
        self.operationQueue = [NSOperationQueue mainQueue];
        self.operationQueue.maxConcurrentOperationCount = 1;

        self.delegate = delegate;
        self.tableView = tableView;
        self.collectionList = collectionList;
        self.animateTableChanges = YES;

        tableView.asyncDataSource = nil;
        tableView.asyncDataSource = self;
        [self setAllSectionAnimations:UITableViewRowAnimationFade];
        [self setAllObjectAnimations:UITableViewRowAnimationFade];
    }

    return self;
}

- (void)dealloc {
    [self.operationQueue cancelAllOperations];

    [self.collectionList removeCollectionListObserver:self];
}

#pragma mark - Setters

- (void)setCollectionList:(id<RZCollectionList>)collectionList {
    if (_collectionList != collectionList) {
        if (_collectionList) {
            [_collectionList removeCollectionListObserver:self];
            _collectionList.delegate = nil;

            NSInteger numSections = [self.tableView numberOfSections];
            if (numSections > 0) {
                NSRange range = NSMakeRange(0, (NSUInteger)numSections);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [self.tableView deleteSections:sections withRowAnimation:self.removeSectionAnimation];
            }
        }

        _collectionList = collectionList;

        if (collectionList) {
            [collectionList addCollectionListObserver:self];
            collectionList.delegate = self;
        }
    }
}

- (void)setAllSectionAnimations:(UITableViewRowAnimation)animation {
    self.addSectionAnimation = animation;
    self.removeSectionAnimation = animation;
}

- (void)setAllObjectAnimations:(UITableViewRowAnimation)animation {
    self.addObjectAnimation = animation;
    self.removeObjectAnimation = animation;
    self.updateObjectAnimation = animation;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)self.collectionList.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <RZCollectionListSectionInfo> sectionInfo = self.collectionList.sections[(NSUInteger)section];

    return (NSInteger)sectionInfo.numberOfObjects;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.collectionList objectAtIndexPath:indexPath];

    return [self.delegate tableView:tableView nodeForObject:object atIndexPath:indexPath];
}

- (void)tableViewLockDataSource:(ASTableView *)tableView {
    self.operationQueue.suspended = YES;
}

- (void)tableViewUnlockDataSource:(ASTableView *)tableView {
    self.operationQueue.suspended = NO;
}

#pragma mark - Collection List Delegate

- (void)collectionList:(id <RZCollectionList>)collectionList didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath forChangeType:(RZCollectionListChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [self.operationQueue addOperationWithBlock:^{
        switch(type) {
            case RZCollectionListChangeInsert:
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:self.addObjectAnimation];
                break;

            case RZCollectionListChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:self.removeObjectAnimation];
                break;

            case RZCollectionListChangeMove:
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;

            case RZCollectionListChangeUpdate: {
                if ([self tableView:self.tableView containsIndexPath:indexPath]) {
                    ASCellNode *node = [self.tableView nodeForRowAtIndexPath:indexPath];

                    if (node) {
                        [self.delegate tableView:self.tableView updateNode:node forObject:object atIndexPath:newIndexPath];
                    }
                }
            }
                break;

            default:
                NSLog(@"We got to the default switch statement we should not have gotten to. The Change Type is: %d", type);
                break;
        }
    }];
}

- (void)collectionList:(id <RZCollectionList>)collectionList didChangeSection:(id <RZCollectionListSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(RZCollectionListChangeType)type {
    [self.operationQueue addOperationWithBlock:^{
        switch(type) {
            case RZCollectionListChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.addSectionAnimation];
                break;

            case RZCollectionListChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:self.removeSectionAnimation];
                break;

            default:
                //uncaught type
                NSLog(@"We got to the default switch statement we should not have gotten to. The Change Type is: %d", type);
                break;
        }
    }];
}

- (void)collectionListWillChangeContent:(id <RZCollectionList>)collectionList {
    [self.operationQueue addOperationWithBlock:^{
        [self.tableView beginUpdates];
    }];
}

- (void)collectionListDidChangeContent:(id <RZCollectionList>)collectionList {
    [self.operationQueue addOperationWithBlock:^{
        [self.tableView endUpdatesAnimated:self.animateTableChanges completion:^(BOOL completed) {
            if ([self.delegate respondsToSelector:@selector(tableView:didFinishUpdatingCompleted:)]) {
                [self.delegate tableView:self.tableView didFinishUpdatingCompleted:completed];
            }
        }];
    }];
}

#pragma mark - Helpers

- (BOOL)tableView:(ASTableView *)tableView containsIndexPath:(NSIndexPath *)indexPath {
    BOOL containsIndexPath = NO;

    if (indexPath.section < tableView.numberOfSections) {
        if (indexPath.row < [tableView numberOfRowsInSection:indexPath.section]) {
            containsIndexPath = YES;
        }
    }
    
    return containsIndexPath;
}

@end
