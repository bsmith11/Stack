//
//  STKEventPoolsViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import Foundation;

@protocol RZCollectionListTableViewDataSourceDelegate;
@class STKEventGroup, STKEventPool, STKEventStanding;

@interface STKEventPoolsViewModel : NSObject

- (instancetype)initWithEventGroup:(STKEventGroup *)group;
- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;

- (STKEventPool *)poolForSection:(NSInteger)section;
- (STKEventStanding *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
