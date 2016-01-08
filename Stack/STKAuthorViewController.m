//
//  STKAuthorViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAuthorViewController.h"
#import "STKPostViewController.h"

#import "STKAuthorViewModel.h"

#import "STKPostNode.h"
#import "STKAuthorNode.h"
#import "STKUnavailableNode.h"

#import "STKPost.h"
#import "STKAuthor.h"

#import "STKCollectionListTableViewDataSource.h"
#import "UIColor+STKStyle.h"
#import "STKAnalyticsManager.h"
#import "UIViewController+STKMail.h"
#import "NSURL+STKExtensions.h"

#import <AsyncDisplayKit/ASTableView.h>
#import <KVOController/FBKVOController.h>
#import <RZDataBinding/RZDBMacros.h>
#import <RZUtils/RZCommonUtils.h>
#import <SSPullToRefresh/SSPullToRefresh.h>
#import <tgmath.h>

@interface STKAuthorViewController () <ASTableViewDelegate, STKCollectionListTableViewDelegate, SSPullToRefreshViewDelegate, STKAuthorNodeDelegate, STKUnavailableNodeDelegate>

@property (strong, nonatomic) STKAuthorViewModel *viewModel;
@property (strong, nonatomic) ASTableView *tableView;
@property (strong, nonatomic) SSPullToRefreshView *refreshView;

@end

@implementation STKAuthorViewController

#pragma mark - Lifecycle

- (instancetype)initWithAuthor:(STKAuthor *)author {
    self = [super init];

    if (self) {
        self.viewModel = [[STKAuthorViewModel alloc] initWithAuthor:author];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupObservers];

    [self.viewModel setupCollectionListDataSourceWithTableView:self.tableView delegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (!self.didLayoutSubviews) {
        self.didLayoutSubviews = YES;

        self.tableView.frame = self.view.bounds;
        [self setupRefreshView];
    }
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:YES];
    self.tableView.backgroundColor = [UIColor stk_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 6.25f, 0.0f);
    self.tableView.asyncDelegate = self;
    self.tableView.alwaysBounceVertical = YES;

    [self.view addSubview:self.tableView];
}

- (void)setupRefreshView {
    if (self.viewModel.enabled) {
        self.refreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
        SSPullToRefreshSimpleContentView *contentView = [[SSPullToRefreshSimpleContentView alloc] initWithFrame:CGRectZero];
        contentView.statusLabel.textColor = [UIColor stk_stackColor];
        contentView.activityIndicatorView.color = [UIColor stk_stackColor];
        self.refreshView.contentView = contentView;
    }
}

- (void)setupObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;

    __weak __typeof(self) wself = self;

    [self.KVOController observe:self.viewModel keyPath:RZDB_KP_OBJ(self.viewModel, downloading) options:options block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *downloading = RZNSNullToNil(change[NSKeyValueChangeNewKey]);

            if (downloading.boolValue) {
//                [wself.spinner startAnimating];
            }
            else {
//                [wself.spinner stopAnimating];

                if (wself.refreshView.state == SSPullToRefreshViewStateLoading) {
                    [wself.refreshView finishLoadingAnimated:YES completion:nil];
                }
            }
        });
    }];
}

#pragma mark - Collection List Data Source Delegate

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node;

    if ([object isKindOfClass:[STKPost class]]) {
        STKPostNode *postNode = [[STKPostNode alloc] init];

        [self tableView:tableView updateNode:postNode forObject:object atIndexPath:indexPath];

        node = postNode;
    }
    else if ([object isKindOfClass:[STKAuthor class]]) {
        STKAuthorNode *authorNode = [[STKAuthorNode alloc] init];

        [self tableView:tableView updateNode:authorNode forObject:object atIndexPath:indexPath];

        node = authorNode;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        STKUnavailableNode *unavailableNode = [[STKUnavailableNode alloc] init];

        [self tableView:tableView updateNode:unavailableNode forObject:object atIndexPath:indexPath];

        node = unavailableNode;
    }

    return node;
}

- (void)tableView:(ASTableView *)tableView updateNode:(ASCellNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([object isKindOfClass:[STKPost class]]) {
        STKPostNode *postNode = (STKPostNode *)node;
        [postNode setupWithPost:object];
    }
    else if ([object isKindOfClass:[STKAuthor class]]) {
        STKAuthorNode *authorNode = (STKAuthorNode *)node;
        [authorNode setupWithAuthor:object];
        authorNode.delegate = self;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        STKUnavailableNode *unavailableNode = (STKUnavailableNode *)node;
        NSString *sournceName = [STKSource nameForType:self.viewModel.author.sourceType.integerValue];
        NSString *message = [NSString stringWithFormat:@"Author articles are currently not available for %@. If you would like to see them supported, let %@ know.", sournceName, sournceName];
        NSString *action = [NSString stringWithFormat:@"Contact %@", sournceName];

        [unavailableNode setupWithTitle:@"Not Available"
                                message:message
                                 action:action
                               delegate:self];
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.viewModel objectAtIndexPath:indexPath];

    if ([object isKindOfClass:[STKPost class]]) {
        STKPost *post = (STKPost *)object;

        [STKAnalyticsManager logEventDidClickPost:post fromAuthor:self.viewModel.author];

        STKPostViewController *postViewController = [[STKPostViewController alloc] initWithPost:post];
        postViewController.transitioningDelegate = postViewController;

        [self presentViewController:postViewController animated:YES completion:nil];
    }
}

- (void)tableView:(ASTableView *)tableView willBeginBatchFetchWithContext:(ASBatchContext *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Fetching additional posts...");

        [self.viewModel fetchOlderPostsWithCompletion:^(STKViewModelFetchResult result) {
            NSLog(@"Received additional posts...");

            if (result == STKViewModelFetchResultFailed || STKViewModelFetchResultCancelled) {
                [context cancelBatchFetching];
            }

            [context completeBatchFetching:[context batchFetchingWasCancelled]];
        }];
    });
}

#pragma mark - Pull To Refresh Delegate

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [view startLoading];

    [self.viewModel fetchNewPostsWithCompletion:nil];
}

#pragma mark - Author Node Delegate

- (void)authorNode:(STKAuthorNode *)node didTapLink:(NSURL *)link {
    if ([[UIApplication sharedApplication] canOpenURL:link]) {
        [[UIApplication sharedApplication] openURL:link];
    }
    else if ([link stk_isMailLink]) {
        NSString *emailAddress = [link stk_emailAddress];
        if (emailAddress) {
            [self stk_presentMailComposeViewControllerWithRecipients:@[emailAddress]];
        }
    }
}

- (void)authorNode:(STKAuthorNode *)node didTapImageWithURL:(NSURL *)URL size:(CGSize)size {

}

#pragma mark - Unavailable Node Delegate

- (void)unavailableNodeDidTapAction:(STKUnavailableNode *)node {
    NSString *sourceName = [STKSource nameForType:self.viewModel.author.sourceType.integerValue];

    NSString *recipient = [STKSource contactEmailForType:self.viewModel.author.sourceType.integerValue];
    NSString *body = [NSString stringWithFormat:@"I'd love to see more %@ support for the Stack app, especially with regards to author pages", sourceName];
    NSString *subject = [NSString stringWithFormat:@"%@ Stack Support", sourceName];
    
    [self stk_presentMailComposeViewControllerWithRecipients:@[recipient] body:body subject:subject];
}

@end
