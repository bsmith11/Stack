//
//  STKPostViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostViewController.h"
#import "STKAuthorViewController.h"
#import "STKImageViewController.h"

#import "STKPostViewModel.h"

#import "STKPost.h"
#import "STKComment.h"
#import "STKAttachment.h"
#import "STKPostParagraphSection.h"
#import "STKPostImageSection.h"
#import "STKPostVideoSection.h"

#import "STKPostSeparatorNode.h"
#import "STKPostInfoNode.h"
#import "STKPostFeatureImageNode.h"
#import "STKPostTitleNode.h"
#import "STKPostParagraphSectionNode.h"
#import "STKPostImageSectionNode.h"
#import "STKPostVideoSectionNode.h"
#import "STKPostCommentNode.h"

#import "STKCollectionListTableViewDataSource.h"
#import "STKAnalyticsManager.h"
#import "UIColor+STKStyle.h"
#import "UIView+STKShadow.h"
#import "NSURL+STKExtensions.h"
#import "UIViewController+STKMail.h"
#import "UIBarButtonItem+STKExtensions.h"

#import <AsyncDisplayKit/ASTableView.h>
#import <KVOController/FBKVOController.h>
#import <RZDataBinding/RZDBMacros.h>
#import <RZUtils/RZCommonUtils.h>
#import <tgmath.h>

@interface STKPostViewController () <ASTableViewDelegate, STKCollectionListTableViewDelegate, STKPostSectionNodeDelegate, STKPostInfoNodeDelegate, STKPostFeatureImageNodeDelegate, STKImageViewControllerDelegate, STKPostCommentNodeDelegate>

@property (strong, nonatomic) STKPostViewModel *viewModel;
@property (strong, nonatomic) ASTableView *tableView;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIBarButtonItem *bookmarkToolbarItem;
@property (strong, nonatomic) ASCellNode *selectedNode;

@property (assign, nonatomic) CGPoint previousContentOffset;

@end

@implementation STKPostViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - Lifecycle

- (instancetype)initWithPost:(STKPost *)post {
    self = [super init];

    if (self) {
        self.viewModel = [[STKPostViewModel alloc] initWithPost:post];
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupTableView];
    [self setupToolbar];
    [self setupToolbarItems];
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
        CGFloat toolbarHeight = 49.0f;
        self.toolbar.frame = CGRectMake(0.0f, CGRectGetHeight(self.view.bounds) - toolbarHeight, CGRectGetWidth(self.view.bounds), toolbarHeight);

        [self.toolbar stk_setupShadow];
    }
}

#pragma mark - Setup

- (void)setupTableView {
    self.tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 49.0f + 12.5f, 0.0f);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 49.0f, 0.0f);
    self.tableView.asyncDelegate = self;

    [self.view addSubview:self.tableView];
}

- (void)setupToolbar {
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.translucent = NO;
    self.toolbar.tintColor = [UIColor whiteColor];
    self.toolbar.barTintColor = [STKSource colorForType:self.viewModel.post.sourceType.integerValue];
    [self.toolbar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
    [self.toolbar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

    [self.view addSubview:self.toolbar];
}

- (void)setupToolbarItems {
    CGFloat interitemSpacing = 50.0f;
    CGFloat width = (25.0f - 16.0f);
    UIBarButtonItem *leftFixedSpaceToolbarItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:width];

    UIImage *backImage = [UIImage imageNamed:@"Back Icon"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackBarButtonItem)];

    UIBarButtonItem *middleLeftFixedSpaceToolbarItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:interitemSpacing];

    UIImage *commentsImage = [UIImage imageNamed:@"Comments Off Icon"];
    UIBarButtonItem *commentsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:commentsImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapCommentsBarButtonItem)];

    UIBarButtonItem *middleRightFixedSpaceToolbarItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:interitemSpacing];

    UIImage *bookmarkImage = [UIImage imageNamed:@"Bookmark Off Icon"];
    self.bookmarkToolbarItem = [[UIBarButtonItem alloc] initWithImage:bookmarkImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBookmarkBarButtonItem)];
    self.bookmarkToolbarItem.imageInsets = UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f);

    UIBarButtonItem *rightFixedSpaceToolbarItem = [UIBarButtonItem stk_fixedSpaceBarButtonItemWithWidth:interitemSpacing];

    UIBarButtonItem *shareToolbarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didTapShareBarButtonItem)];
    shareToolbarItem.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 3.0f, 0.0f);
    shareToolbarItem.enabled = (self.viewModel.post.link != nil);

    [self.toolbar setItems:@[leftFixedSpaceToolbarItem, backBarButtonItem, middleLeftFixedSpaceToolbarItem, commentsBarButtonItem, middleRightFixedSpaceToolbarItem, self.bookmarkToolbarItem, rightFixedSpaceToolbarItem, shareToolbarItem] animated:NO];
}

- (void)setupObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;

    __weak __typeof(self) wself = self;

    [self.KVOController observe:self.viewModel.post keyPath:RZDB_KP_OBJ(self.viewModel.post, bookmarked) options:options block:^(id observer, id object, NSDictionary *change) {
        NSNumber *bookmarked = RZNSNullToNil(change[NSKeyValueChangeNewKey]);
        UIImage *image;

        if (bookmarked.boolValue) {
            image = [UIImage imageNamed:@"Bookmark On Icon"];
        }
        else {
            image = [UIImage imageNamed:@"Bookmark Off Icon"];
        }

        wself.bookmarkToolbarItem.image = image;
    }];
}

#pragma mark - Actions

- (void)didTapBackBarButtonItem {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapCommentsBarButtonItem {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didTapBookmarkBarButtonItem {
    [STKAnalyticsManager logEventDidBookmarkPost:self.viewModel.post enabled:!self.viewModel.post.bookmarked.boolValue];

    [self.viewModel.post bookmark];
}

- (void)didTapShareBarButtonItem {
    STKPost *post = self.viewModel.post;
    [STKAnalyticsManager logEventDidClickShareForPost:post];

    NSURL *URL = [NSURL URLWithString:self.viewModel.post.link];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (completed) {
            [STKAnalyticsManager logEventDidSharePost:post activityType:activityType];
        }
        else {
            [STKAnalyticsManager logEventDidCancelShareForPost:post];
        }
    };

    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Collection List Data Source

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *node;

    if ([object isKindOfClass:[STKAttachment class]]) {
        STKAttachment *attachment = (STKAttachment *)object;
        STKPostFeatureImageNode *featureImageNode = [[STKPostFeatureImageNode alloc] init];
        [featureImageNode setupWithAttachment:attachment];
        featureImageNode.delegate = self;

        node = featureImageNode;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@"title"]) {
            STKPostTitleNode *titleNode = [[STKPostTitleNode alloc] init];
            [titleNode setupWithPost:self.viewModel.post];

            node = titleNode;
        }
        else if ([object isEqualToString:@"info"]) {
            STKPostInfoNode *infoNode = [[STKPostInfoNode alloc] init];
            [infoNode setupWithPost:self.viewModel.post];
            infoNode.delegate = self;

            node = infoNode;
        }
        else if ([object isEqualToString:@"separator"]) {
            node = [[STKPostSeparatorNode alloc] init];
        }
    }
    else if ([object isKindOfClass:[STKPostParagraphSection class]]) {
        STKPostParagraphSection *section = (STKPostParagraphSection *)object;
        STKPostParagraphSectionNode *sectionNode = [[STKPostParagraphSectionNode alloc] init];
        [sectionNode setupWithSection:section];
        sectionNode.delegate = self;

        node = sectionNode;
    }
    else if ([object isKindOfClass:[STKPostImageSection class]]) {
        STKPostImageSection *section = (STKPostImageSection *)object;
        STKPostImageSectionNode *sectionNode = [[STKPostImageSectionNode alloc] init];
        [sectionNode setupWithSection:section];
        sectionNode.delegate = self;

        node = sectionNode;
    }
    else if ([object isKindOfClass:[STKPostVideoSection class]]) {
        STKPostVideoSection *section = (STKPostVideoSection *)object;
        STKPostVideoSectionNode *sectionNode = [[STKPostVideoSectionNode alloc] init];
        [sectionNode setupWithSection:section];
        sectionNode.delegate = self;

        node = sectionNode;
    }
    else if ([object isKindOfClass:[STKComment class]]) {
        STKComment *comment = (STKComment *)object;
        STKPostCommentNode *commentNode = [[STKPostCommentNode alloc] init];
        commentNode.delegate = self;

        [commentNode setupWithComment:comment];

        node = commentNode;
    }

    return node;
}

- (void)tableView:(ASTableView *)tableView updateNode:(ASCellNode *)node forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self updateToolbarFrameForScrollView:scrollView];

    self.previousContentOffset = scrollView.contentOffset;
}

- (void)updateToolbarFrameForScrollView:(UIScrollView *)scrollView {
    CGRect toolbarFrame = self.toolbar.frame;
    CGFloat min = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.toolbar.frame);
    CGFloat max = CGRectGetHeight(self.view.frame);

    if (scrollView.contentOffset.y < scrollView.contentInset.top) {
        toolbarFrame.origin.y = min;
    }
    else if ((scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame)) > (scrollView.contentSize.height + scrollView.contentInset.bottom)) {
        toolbarFrame.origin.y = max;
    }
    else {
        CGFloat delta = self.previousContentOffset.y - scrollView.contentOffset.y;
        toolbarFrame.origin.y = RZClampFloat(toolbarFrame.origin.y - delta, min, max);
    }

    self.toolbar.frame = toolbarFrame;

    UIEdgeInsets insets = scrollView.scrollIndicatorInsets;
    insets.bottom = CGRectGetHeight(scrollView.frame) - CGRectGetMinY(self.toolbar.frame);
    scrollView.scrollIndicatorInsets = insets;
}

#pragma mark - Post Section Node Delegate

- (void)postSectionNode:(STKPostSectionNode *)node didTapLink:(NSURL *)link {
    [STKAnalyticsManager logEventDidClickLink:link fromPost:self.viewModel.post];

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

- (void)postSectionNode:(STKPostSectionNode *)node didTapImageWithURL:(NSURL *)URL size:(CGSize)size {
    [STKAnalyticsManager logEventDidClickMediaWithURL:URL fromPost:self.viewModel.post];

    self.selectedNode = node;

    CGRect originalRect = [((STKPostImageSectionNode *)node) imageNodeFrame];
    originalRect = [self.view convertRect:originalRect fromView:node.view];

    STKImageViewController *imageViewController = [[STKImageViewController alloc] initWithURL:URL originalRect:originalRect];
    imageViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imageViewController.delegate = self;

    [self presentViewController:imageViewController animated:NO completion:nil];
}

#pragma mark - Post Feature Image Node Delegate

- (void)postFeatureImageNodeDidSelectAttachment:(STKPostFeatureImageNode *)node {
    STKAttachment *attachment = self.viewModel.post.attachment;

    if (attachment.sourceURL.length > 0) {
        NSURL *URL = [NSURL URLWithString:attachment.sourceURL];

        [STKAnalyticsManager logEventDidClickMediaWithURL:URL fromPost:self.viewModel.post];

        self.selectedNode = node;

        NSIndexPath *indexPath = [self.tableView indexPathForNode:node];
        CGRect originalRect = [self.tableView rectForRowAtIndexPath:indexPath];
        originalRect = [self.view convertRect:originalRect fromView:self.tableView];

        STKImageViewController *imageViewController = [[STKImageViewController alloc] initWithURL:URL originalRect:originalRect];
        imageViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        imageViewController.delegate = self;

        [self presentViewController:imageViewController animated:NO completion:nil];
    }
}

#pragma mark - Post Info Node Delegate

- (void)postInfoNodeDidSelectAuthor:(STKPostInfoNode *)node {
    STKAuthor *author = self.viewModel.post.author;

    [STKAnalyticsManager logEventDidClickAuthor:author fromPost:self.viewModel.post];

    STKAuthorViewController *authorViewController = [[STKAuthorViewController alloc] initWithAuthor:author];
    authorViewController.transitioningDelegate = authorViewController;

    [self presentViewController:authorViewController animated:YES completion:nil];
}

#pragma mark - Post Comment Node Delegate

- (void)postCommentNode:(STKPostCommentNode *)node didTapLink:(NSURL *)link {
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

#pragma mark - Image View Controller Delegate

- (void)imageViewControllerWillStartPresentAnimation:(STKImageViewController *)imageViewController {
    self.selectedNode.hidden = YES;
}

- (void)imageViewControllerDidFinishDismissAnimation:(STKImageViewController *)imageViewController {
    self.selectedNode.hidden = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
