//
//  STKBookmarksViewModel.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STKCollectionListTableViewDelegate;
@class ASTableView;

@interface STKBookmarksViewModel : NSObject

- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id <STKCollectionListTableViewDelegate>)delegate;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;

@property (assign, nonatomic, readonly) BOOL empty;

@end
