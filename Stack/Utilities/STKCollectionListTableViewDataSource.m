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
    __weak __typeof(self) wself = self;

    [self.operationQueue addOperationWithBlock:^{
        switch(type) {
            case RZCollectionListChangeInsert:
                [wself.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:wself.addObjectAnimation];
                break;

            case RZCollectionListChangeDelete:
                [wself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:wself.removeObjectAnimation];
                break;

            case RZCollectionListChangeMove:
                [wself.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;

            case RZCollectionListChangeUpdate: {
                if ([wself tableView:wself.tableView containsIndexPath:indexPath]) {
                    ASCellNode *node = [wself.tableView nodeForRowAtIndexPath:indexPath];

                    if (node) {
                        [wself.delegate tableView:wself.tableView updateNode:node forObject:object atIndexPath:newIndexPath];
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
    __weak __typeof(self) wself = self;

    [self.operationQueue addOperationWithBlock:^{
        switch(type) {
            case RZCollectionListChangeInsert:
                [wself.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:wself.addSectionAnimation];
                break;

            case RZCollectionListChangeDelete:
                [wself.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:wself.removeSectionAnimation];
                break;

            default:
                //uncaught type
                NSLog(@"We got to the default switch statement we should not have gotten to. The Change Type is: %d", type);
                break;
        }
    }];
}

- (void)collectionListWillChangeContent:(id <RZCollectionList>)collectionList {
    __weak __typeof(self) wself = self;

    [self.operationQueue addOperationWithBlock:^{
        [wself.tableView beginUpdates];
    }];
}

- (void)collectionListDidChangeContent:(id <RZCollectionList>)collectionList {
    __weak __typeof(self) wself = self;

    [self.operationQueue addOperationWithBlock:^{
        [wself.tableView endUpdatesAnimated:wself.animateTableChanges completion:^(BOOL completed) {
            if ([wself.delegate respondsToSelector:@selector(tableView:didFinishUpdatingCompleted:)]) {
                [wself.delegate tableView:wself.tableView didFinishUpdatingCompleted:completed];
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
