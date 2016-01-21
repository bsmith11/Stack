//
//  STKFeedViewModel.h
//  Stack
//
//  Created by Bradley Smith on 12/21/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

//TODO: Abstract out this enum

typedef NS_ENUM(NSInteger, STKViewModelFetchResult) {
    STKViewModelFetchResultSuccessNone,
    STKViewModelFetchResultSuccessNew,
    STKViewModelFetchResultSuccessNewGap,
    STKViewModelFetchResultCancelled,
    STKViewModelFetchResultFailed
};

typedef void (^STKViewModelFetchCompletion)(STKViewModelFetchResult result);

@protocol STKTableViewDataSourceDelegate;
@class ASTableView;

@interface STKFeedViewModel : NSObject

- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id <STKTableViewDataSourceDelegate>)delegate;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (void)fetchNewPostsWithCompletion:(STKViewModelFetchCompletion)completion;
- (void)fetchOlderPostsWithCompletion:(STKViewModelFetchCompletion)completion;
- (void)updatePostsForSourceType:(STKSourceType)sourceType completion:(STKViewModelFetchCompletion)completion;
- (void)removePostsBeforeGap;

@property (copy, nonatomic, readonly) NSString *title;

@property (assign, nonatomic, readonly) STKSourceType sourceType;
@property (assign, nonatomic, readonly) BOOL downloading;

@end
