//
//  STKAuthorViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAuthorViewModel.h"

#import "STKAuthor.h"
#import "STKPost.h"

#import "STKContentManager.h"
#import "STKCollectionListTableViewDataSource.h"

#import <RZCollectionList/RZCollectionList.h>

@interface STKAuthorViewModel ()

@property (strong, nonatomic, readwrite) STKAuthor *author;
@property (strong, nonatomic) RZArrayCollectionList *postsArrayList;
@property (strong, nonatomic) RZSortedCollectionList *posts;
@property (strong, nonatomic, readwrite) RZCompositeCollectionList *objects;
@property (strong, nonatomic) STKCollectionListTableViewDataSource *dataSource;

@property (assign, nonatomic, readwrite) BOOL downloading;
@property (assign, nonatomic, readwrite) BOOL enabled;

@end

@implementation STKAuthorViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAuthor:(STKAuthor *)author {
    self = [super init];

    if (self) {
        self.author = author;
        self.enabled = [[STKSource sourcesWithAuthorAvailable] containsObject:author.sourceType];

        [self setupObjects];

        [self fetchNewPostsWithCompletion:nil];
    }

    return self;
}

#pragma mark - Setup

- (void)setupObjects {
    NSMutableArray *sourceLists = [NSMutableArray array];

    RZArrayCollectionList *authorList = [[RZArrayCollectionList alloc] initWithArray:@[self.author] sectionNameKeyPath:nil];
    [sourceLists addObject:authorList];

    if (self.enabled) {
        self.postsArrayList = [[RZArrayCollectionList alloc] initWithArray:[NSArray array] sectionNameKeyPath:nil];
        self.posts = [[RZSortedCollectionList alloc] initWithSourceList:self.postsArrayList sortDescriptors:@[[STKPost createDateSortDescriptor]]];

        [sourceLists addObject:self.posts];
    }
    else {
        RZArrayCollectionList *notAvailableList = [[RZArrayCollectionList alloc] initWithArray:@[@"Not Available"] sectionNameKeyPath:nil];
        [sourceLists addObject:notAvailableList];
    }

    self.objects = [[RZCompositeCollectionList alloc] initWithSourceLists:sourceLists];
}

- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKCollectionListTableViewDelegate>)delegate {
    self.dataSource = [[STKCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.objects delegate:delegate];
    self.dataSource.animateTableChanges = NO;
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.objects objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return [self.objects indexPathForObject:object];
}

- (void)fetchNewPostsWithCompletion:(STKViewModelFetchCompletion)completion {
    [self fetchPostsBeforePosts:nil completion:completion];
}

- (void)fetchOlderPostsWithCompletion:(STKViewModelFetchCompletion)completion {
    [self fetchPostsBeforePosts:self.posts.listObjects completion:completion];
}

- (void)fetchPostsBeforePosts:(NSArray *)posts completion:(STKViewModelFetchCompletion)completion {
    if (self.enabled) {
        self.downloading = YES;

        __weak __typeof(self) wself = self;

        void (^fetchCompletion)(NSArray *, NSError *) = ^(NSArray *fetchedPosts, NSError *error) {
            wself.downloading = NO;

            if (!error) {
                [wself updatePostsWithPosts:fetchedPosts];
            }

            STKViewModelFetchResult result;
            if (error || fetchedPosts.count == 0) {
                result = STKViewModelFetchResultFailed;
            }
            else {
                result = STKViewModelFetchResultSuccessNew;
            }

            if (completion) {
                completion(result);
            }
        };

        [STKContentManager downloadPostsBeforePosts:posts
                                             author:self.author
                                         completion:fetchCompletion];
    }
    else {
        if (completion) {
            completion(STKViewModelFetchResultFailed);
        }
    }
}

- (void)updatePostsWithPosts:(NSArray *)posts {
    [self.postsArrayList beginUpdates];

    for (STKPost *postObject in posts) {
        if (![self.postsArrayList.listObjects containsObject:postObject]) {
            [self.postsArrayList addObject:postObject toSection:0];
        }
    }

    [self.postsArrayList endUpdates];
}

@end
