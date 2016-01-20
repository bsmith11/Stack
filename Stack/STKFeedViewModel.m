//
//  STKFeedViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKFeedViewModel.h"

#import "STKPost.h"

#import "STKCoreDataStack.h"
#import "STKSettingsViewModel.h"
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

        [self setupObservers];
    }

    return self;
}

- (void)setSourceType:(STKSourceType)sourceType {
    _sourceType = sourceType;

    self.title = [STKSource nameForType:sourceType] ?: @"Stack";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSTKSettingsClearCacheNotification object:nil];
}

#pragma mark - Setup

- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[STKTableViewDataSource alloc] initWithTableView:tableView
                                                               objects:[NSArray array]
                                                       sortDescriptors:@[[STKPost createDateSortDescriptor]]
                                                              delegate:delegate];

    self.dataSource.animateChanges = NO;
    [self.dataSource registerForChangeNotificationsForContext:[STKCoreDataStack defaultStack].mainManagedObjectContext entityName:[STKPost rzv_entityName]];
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveClearCacheNotification) name:kSTKSettingsClearCacheNotification object:nil];
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.objects objectAtIndex:(NSUInteger)indexPath.row];
}

- (void)updatePostsForSourceType:(STKSourceType)sourceType completion:(STKViewModelFetchCompletion)completion {
    self.sourceType = sourceType;
    [self.fetchIDs removeAllObjects];
    self.downloading = NO;

    NSArray *posts = [STKPost fetchPostsBeforePost:nil
                                            author:nil
                                        sourceType:sourceType];

//    __weak __typeof(self) wself = self;
//    [STKPost fetchPostsBeforePost:nil
//                           author:nil
//                       sourceType:sourceType
//                       completion:^(NSAsynchronousFetchResult * _Nonnull result) {
//                           NSArray *posts = result.finalResult;
//
//                           BOOL previousValue = wself.dataSource.tableView.automaticallyAdjustsContentOffset;
//                           wself.dataSource.tableView.automaticallyAdjustsContentOffset = NO;
//
//                           [wself.dataSource replaceAllObjectsWithObjects:posts completion:^{
//                               CGPoint contentOffset = wself.dataSource.tableView.contentOffset;
//                               contentOffset.y = -wself.dataSource.tableView.contentInset.top;
//                               [wself.dataSource.tableView setContentOffset:contentOffset animated:NO];
//                               
//                               wself.dataSource.tableView.automaticallyAdjustsContentOffset = previousValue;
//                           }];
//                       }];

    BOOL previousValue = self.dataSource.tableView.automaticallyAdjustsContentOffset;
    self.dataSource.tableView.automaticallyAdjustsContentOffset = NO;

    __weak __typeof(self) wself = self;
    [self.dataSource replaceAllObjectsWithObjects:posts completion:^{
        CGPoint contentOffset = wself.dataSource.tableView.contentOffset;
        contentOffset.y = -wself.dataSource.tableView.contentInset.top;
        [wself.dataSource.tableView setContentOffset:contentOffset animated:NO];

        wself.dataSource.tableView.automaticallyAdjustsContentOffset = previousValue;
    }];

    [self fetchNewPostsWithCompletion:completion];
}

- (void)removePostsBeforeGap {
    NSLog(@"Removing posts before gap...");
    if (self.dataSource.objects.count > 10) {
        [self.fetchIDs removeAllObjects];
        self.downloading = NO;

        BOOL previousValue = self.dataSource.tableView.automaticallyAdjustsContentOffset;
        self.dataSource.tableView.automaticallyAdjustsContentOffset = NO;

        NSRange range = NSMakeRange(10, self.dataSource.objects.count - 10);
        NSArray *objectsToRemove = [self.dataSource.objects subarrayWithRange:range];

        __weak __typeof(self) wself = self;
        [self.dataSource removeObjects:objectsToRemove completion:^(NSArray *removedObjects) {
            wself.dataSource.tableView.automaticallyAdjustsContentOffset = previousValue;
        }];
    }
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

        if (!error) {
            if ([wself.fetchIDs containsObject:fetchID]) {
                [wself.fetchIDs removeObject:fetchID];

                [wself.dataSource addObjects:fetchedPosts completion:^(NSArray *newObjects) {
                    STKViewModelFetchResult result;
                    if (newObjects.count > 0) {
                        if (posts || newObjects.count < 10) {
                            NSLog(@"Success New");
                            result = STKViewModelFetchResultSuccessNew;
                        }
                        else {
                            NSLog(@"Success Gap");
                            result = STKViewModelFetchResultSuccessNewGap;
                        }
                    }
                    else {
                        result = STKViewModelFetchResultSuccessNone;
                    }

                    if (completion) {
                        completion(result);
                    }
                }];
            }
            else {
                if (completion) {
                    completion(STKViewModelFetchResultCancelled);
                }
            }
        }
        else {
            if (completion) {
                completion(STKViewModelFetchResultFailed);
            }
        }

        if (wself.fetchIDs.count == 0) {
            wself.downloading = NO;
        }
    };

    [STKContentManager downloadPostsBeforePosts:posts
                                     sourceType:self.sourceType
                                     completion:fetchCompletion];
}

- (void)didReceiveClearCacheNotification {
    [self.fetchIDs removeAllObjects];
    self.downloading = NO;

    __weak __typeof(self) wself = self;
    [self.dataSource replaceAllObjectsWithObjects:nil completion:^{
        [wself fetchNewPostsWithCompletion:nil];
    }];
}

@end
