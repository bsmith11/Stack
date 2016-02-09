//
//  STKEventsViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKEvent;

@protocol RZCollectionListTableViewDataSourceDelegate;

@interface STKEventsViewModel : NSObject

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;

- (STKEvent *)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForSection:(NSUInteger)section;
- (NSInteger)sectionForDate:(NSDate *)date;

- (void)searchForText:(NSString *)text;
- (void)downloadEventsWithCompletion:(void (^)(NSError *))completion;

@property (assign, nonatomic, readonly) BOOL downloading;

@end
