//
//  STKAuthorViewModel.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

//TODO: Abstract out this enum
#import "STKFeedViewModel.h"

@class ASTableView, STKAuthor;

@protocol STKCollectionListTableViewDelegate;

@interface STKAuthorViewModel : NSObject

- (instancetype)initWithAuthor:(STKAuthor *)author;
- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id <STKCollectionListTableViewDelegate>)delegate;

- (void)fetchNewPostsWithCompletion:(STKViewModelFetchCompletion)completion;
- (void)fetchOlderPostsWithCompletion:(STKViewModelFetchCompletion)completion;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@property (strong, nonatomic, readonly) STKAuthor *author;

@property (assign, nonatomic, readonly) BOOL downloading;
@property (assign, nonatomic, readonly) BOOL enabled;

@end
