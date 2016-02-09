//
//  STKEventsViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventsViewModel.h"

#import "STKEvent.h"

#import "STKAttributes.h"
#import "UIFont+STKStyle.h"

#import <RZCollectionList/RZCollectionList.h>
#import <RZDataBinding/RZDataBinding.h>

@interface STKEventsViewModel ()

@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZFilteredCollectionList *events;

@property (assign, nonatomic, readwrite) BOOL downloading;

@end

@implementation STKEventsViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self downloadEventsWithCompletion:nil];
        [self setupEvents];
    }

    return self;
}

#pragma mark - Setup

- (void)setupEvents {
    RZFetchedCollectionList *fetchedList = [STKEvent fetchedListOfEvents];
    self.events = [[RZFilteredCollectionList alloc] initWithSourceList:fetchedList predicate:nil filterOutEmptySections:YES];
}

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.events delegate:delegate];
    self.dataSource.animateTableChanges = NO;
}

#pragma mark - Actions

- (STKEvent *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.collectionList objectAtIndexPath:indexPath];
}

- (NSDate *)dateForSection:(NSUInteger)section {
    STKEvent *event = [self.events.sections[section] objects].firstObject;

    return event.startDate;
}

- (NSInteger)sectionForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startOfWeek;
    NSDate *endOfWeek;
    NSTimeInterval interval;

    [calendar rangeOfUnit:NSWeekCalendarUnit
                startDate:&startOfWeek
                 interval:&interval
                  forDate:date];
    endOfWeek = [startOfWeek dateByAddingTimeInterval:interval - 1.0];

    NSPredicate *weekPredicate = [NSPredicate predicateWithFormat:@"%K => %@ && %K <= %@", RZDB_KP(STKEvent, startDate), startOfWeek, RZDB_KP(STKEvent, startDate), endOfWeek];

    STKEvent *event = [self.events.listObjects filteredArrayUsingPredicate:weekPredicate].firstObject;
    return [self.events indexPathForObject:event].section;
}

- (void)searchForText:(NSString *)text {
    NSPredicate *predicate;

    if (text.length > 0) {
        predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", RZDB_KP(STKEvent, name), text];
    }
    else {
        predicate = nil;
    }

    self.events.predicate = predicate;
}

- (void)downloadEventsWithCompletion:(void (^)(NSError *))completion {
    self.downloading = YES;

    __weak __typeof(self) wself = self;
    [STKEvent downloadEventsWithCompletion:^(NSError * _Nonnull error) {
        wself.downloading = NO;

        if (completion) {
            completion(error);
        }
    }];
}

@end
