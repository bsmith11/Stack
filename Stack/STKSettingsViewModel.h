//
//  STKSettingsViewModel.h
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STKCollectionListTableViewDelegate;
@class ASTableView;

@protocol STKSettingsViewModelDelegate <NSObject>

- (void)presentMailViewController;

@end

@interface STKSettingsViewModel : NSObject

- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKCollectionListTableViewDelegate>)delegate;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@property (weak, nonatomic) id <STKSettingsViewModelDelegate> delegate;

@end
