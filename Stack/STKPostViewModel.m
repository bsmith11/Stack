//
//  STKPostViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostViewModel.h"

#import "STKPost.h"
#import "STKPostSection.h"
#import "STKComment.h"

#import "STKCollectionListTableViewDataSource.h"

@interface STKPostViewModel ()

@property (strong, nonatomic, readwrite) STKPost *post;
@property (strong, nonatomic) RZCompositeCollectionList *objects;
@property (strong, nonatomic) STKCollectionListTableViewDataSource *dataSource;

@property (assign, nonatomic, readwrite) BOOL downloading;

@end

@implementation STKPostViewModel

#pragma mark - Lifecycle

- (instancetype)initWithPost:(STKPost *)post {
    self = [super init];

    if (self) {
        self.post = post;

        [self setupObjects];

        self.downloading = YES;
        [STKComment downloadCommentsForPost:post completion:^(NSError * _Nonnull error) {
            self.downloading = NO;
        }];
    }

    return self;
}

#pragma mark - Setup

- (void)setupObjects {
    RZFetchedCollectionList *sections = [STKPostSection fetchedSectionsForPost:self.post];

    NSMutableArray *array = [NSMutableArray array];
    if (self.post.attachment) {
        [array addObject:self.post.attachment];
    }

    [array addObject:@"title"];
    [array addObject:@"info"];
    [array addObject:@"separator"];

    RZArrayCollectionList *info = [[RZArrayCollectionList alloc] initWithArray:array sectionNameKeyPath:nil];
    RZArrayCollectionList *commentsInfo = [[RZArrayCollectionList alloc] initWithArray:@[@"separator"] sectionNameKeyPath:nil];
    RZFetchedCollectionList *comments = [STKComment fetchedListOfCommentsForPost:self.post];

    self.objects = [[RZCompositeCollectionList alloc] initWithSourceLists:@[info, sections, commentsInfo, comments]];
}

- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKCollectionListTableViewDelegate>)delegate {
    self.dataSource = [[STKCollectionListTableViewDataSource alloc] initWithTableView:tableView
                                                                       collectionList:self.objects
                                                                             delegate:delegate];
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.objects objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return [self.objects indexPathForObject:object];
}

@end
