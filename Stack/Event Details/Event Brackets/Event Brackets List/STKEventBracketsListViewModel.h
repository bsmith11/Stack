//
//  STKEventBracketsListViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZCollectionListTableViewDataSourceDelegate;
@class STKEventGroup, STKEventBracket;

@interface STKEventBracketsListViewModel : NSObject

- (instancetype)initWithEventGroup:(STKEventGroup *)group;

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;

- (STKEventBracket *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
