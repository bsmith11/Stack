//
//  STKEventsViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKEvent;

@interface STKEventsViewModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (STKEvent *)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForSection:(NSUInteger)section;
- (NSInteger)sectionForDate:(NSDate *)date;

- (void)searchForText:(NSString *)text;
- (void)downloadEventsWithCompletion:(void (^)(NSError *))completion;

@property (weak, nonatomic) UITableView *tableView;

@property (assign, nonatomic, readonly) BOOL downloading;

@end
