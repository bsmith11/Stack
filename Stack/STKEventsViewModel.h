//
//  STKEventsViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import UIKit;

#import "STKEventGroup.h"

@protocol RZCollectionListTableViewDataSourceDelegate;

@interface STKEventsViewModel : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id <RZCollectionListTableViewDataSourceDelegate>)delegate;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)sectionObjectForSection:(NSUInteger)section;
- (NSInteger)sectionForDate:(NSDate *)date;

- (NSIndexPath *)indexPathForSelectedType;
- (NSIndexPath *)indexPathForSelectedDivision;

- (void)searchForText:(NSString *)text;
- (void)downloadEventsWithCompletion:(void (^)(NSError *))completion;

@property (copy, nonatomic, readonly) NSString *title;

@property (assign, nonatomic, readonly) STKEventGroupType type;
@property (assign, nonatomic, readonly) STKEventGroupDivision division;
@property (assign, nonatomic, readonly) BOOL downloading;

@end
