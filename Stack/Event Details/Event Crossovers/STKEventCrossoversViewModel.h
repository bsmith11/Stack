//
//  STKEventCrossoversViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZCollectionListTableViewDataSourceDelegate;
@class STKEventCluster, STKEventGame, STKEventGroup;

@interface STKEventCrossoversViewModel : NSObject

- (instancetype)initWithEventGroup:(STKEventGroup *)group;

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;

- (NSDate *)dateForSection:(NSInteger)section;
- (STKEventGame *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
