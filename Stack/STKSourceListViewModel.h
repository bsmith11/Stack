//
//  STKSourceListViewModel.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, STKSourceListType) {
    STKSourceListTypeAll,
    STKSourceListTypeSearchAvailable,
    STKSourceListTypeNotificationsAvailable
};

@protocol STKTableViewDataSourceDelegate;
@class ASTableView;

@interface STKSourceListViewModel : NSObject

- (instancetype)initWithSourceListType:(STKSourceListType)sourceListType;
- (void)setupDataSourceWithTableView:(ASTableView *)tableView delegate:(id <STKTableViewDataSourceDelegate>)delegate;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@property (assign, nonatomic, readonly) STKSourceType sourceType;

@end
