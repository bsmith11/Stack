//
//  STKPostViewModel.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@protocol STKCollectionListTableViewDelegate;
@class STKPost, ASTableView;

@interface STKPostViewModel : NSObject

- (instancetype)initWithPost:(STKPost *)post;
- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id <STKCollectionListTableViewDelegate>)delegate;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@property (strong, nonatomic, readonly) STKPost *post;

@property (assign, nonatomic, readonly) BOOL downloading;

@end
