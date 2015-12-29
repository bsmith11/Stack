//
//  STKFeedViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKFeedViewModel.h"

#import "STKPost.h"

#import "STKTableViewDataSource.h"
#import "STKContentManager.h"
#import "STKAPIClient.h"

@interface STKFeedViewModel ()

@property (strong, nonatomic) STKTableViewDataSource *dataSource;
@property (strong, nonatomic, readwrite) UITabBarItem *tabBarItem;
@property (strong, nonatomic, readwrite) NSError *networkError;
@property (strong, nonatomic) NSMutableArray *fetchIDs;

@property (copy, nonatomic, readwrite) NSString *title;

@property (assign, nonatomic, readwrite) STKSourceType sourceType;
@property (assign, nonatomic, readwrite) BOOL downloading;

@end

@implementation STKFeedViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.sourceType = -1;
        self.fetchIDs = [NSMutableArray array];
    }

    return self;
}

- (void)setSourceType:(STKSourceType)sourceType {
    _sourceType = sourceType;

    self.title = [STKSource nameForType:sourceType] ?: @"Stack";
}

#pragma mark - Setup

- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[STKTableViewDataSource alloc] initWithTableView:tableView
                                                               objects:[NSArray array]
                                                       sortDescriptors:@[[STKPost createDateSortDescriptor]]
                                                              delegate:delegate];
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.objects objectAtIndex:(NSUInteger)indexPath.row];
}

- (void)updatePostsForSourceType:(STKSourceType)sourceType {
    self.sourceType = sourceType;
    [self.fetchIDs removeAllObjects];
    self.downloading = NO;

    NSArray *posts = [STKPost fetchPostsBeforePost:nil
                                            author:nil
                                        sourceType:sourceType];

    [self.dataSource replaceAllObjectsWithObjects:posts];
    CGFloat topInset = -self.dataSource.tableView.contentInset.top;
    [self.dataSource.tableView setContentOffset:CGPointMake(0.0f, topInset) animated:NO];

    [self fetchNewPostsWithCompletion:nil];
}

- (void)fetchNewPostsWithCompletion:(STKViewModelFetchCompletion)completion {
    [self fetchPostsBeforePosts:nil completion:completion];
}

- (void)fetchOlderPostsWithCompletion:(STKViewModelFetchCompletion)completion {
    [self fetchPostsBeforePosts:self.dataSource.objects completion:completion];
}

- (void)fetchPostsBeforePosts:(NSArray *)posts completion:(STKViewModelFetchCompletion)completion {
    self.downloading = YES;

    NSUUID *fetchID = [NSUUID UUID];
    [self.fetchIDs addObject:fetchID];

    __weak __typeof(self) wself = self;

    STKContentManagerDownloadCompletion fetchCompletion = ^(NSArray *fetchedPosts, NSError *error) {
        wself.networkError = error;

        STKViewModelFetchResult result;

        if ([wself.fetchIDs containsObject:fetchID]) {
            [wself.fetchIDs removeObject:fetchID];

            [wself.dataSource addObjects:fetchedPosts];

            result = error ? STKViewModelFetchResultFailed : STKViewModelFetchResultSuccess;
        }
        else {
            result = STKViewModelFetchResultCancelled;
        }

        if (wself.fetchIDs.count == 0) {
            wself.downloading = NO;
        }

        if (completion) {
            completion(result);
        }
    };

    [STKContentManager downloadPostsBeforePosts:posts
                                     sourceType:self.sourceType
                                     completion:fetchCompletion];
}

@end
