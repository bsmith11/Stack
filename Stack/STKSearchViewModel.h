//
//  STKSearchViewModel.h
//  Stack
//
//  Created by Bradley Smith on 12/26/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STKTableViewDataSourceDelegate;
@class ASTableView;

@interface STKSearchViewModel : NSObject

- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id <STKTableViewDataSourceDelegate>)delegate;
- (void)searchPostsWithText:(NSString *)text;
- (void)cancelSearch;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@property (assign, nonatomic) STKSourceType sourceType;
@property (assign, nonatomic, readonly) BOOL searching;

@end
