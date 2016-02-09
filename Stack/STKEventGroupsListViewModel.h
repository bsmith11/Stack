//
//  STKEventGroupsListViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZCollectionListTableViewDataSourceDelegate;
@class STKEvent, STKEventGroup;

@interface STKEventGroupsListViewModel : NSObject

- (instancetype)initWithEvent:(STKEvent *)event;

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;

- (STKEventGroup *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
