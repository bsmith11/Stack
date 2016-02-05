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

static NSString * const kSTKUserDefaultsKeyEventGroupType = @"com.bradsmith.stack.userDefaults.eventGroupType";
static NSString * const kSTKUserDefaultsKeyEventGroupDivision = @"com.bradsmith.stack.userDefaults.eventGroupDivision";

@interface STKEventsViewModel ()

@property (strong, nonatomic) RZCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZFilteredCollectionList *events;
@property (strong, nonatomic) RZFilteredCollectionList *searchEvents;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) NSArray *divisions;

@property (copy, nonatomic, readwrite) NSString *title;

@property (assign, nonatomic, readwrite) STKEventGroupType type;
@property (assign, nonatomic, readwrite) STKEventGroupDivision division;
@property (assign, nonatomic, readwrite) BOOL downloading;

@end

@implementation STKEventsViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.types = @[@(STKEventGroupTypeClub),
                       @(STKEventGroupTypeCollege),
                       @(STKEventGroupTypeMasters),
                       @(STKEventGroupTypeHighSchool),
                       @(STKEventGroupTypeMiddleSchool)];
        self.divisions = [NSArray array];

        [self downloadEventsWithCompletion:nil];
        [self setupEvents];
    }

    return self;
}

- (void)setType:(STKEventGroupType)type {
    if (_type != type) {
        _type = type;

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:type forKey:kSTKUserDefaultsKeyEventGroupType];
        [userDefaults synchronize];
    }
}

- (void)setDivision:(STKEventGroupDivision)division {
    if (_division != division) {
        _division = division;

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:division forKey:kSTKUserDefaultsKeyEventGroupDivision];
        [userDefaults synchronize];
    }
}

#pragma mark - Setup

- (void)setupEvents {
    RZFetchedCollectionList *fetchedList = [STKEvent fetchedListOfEvents];
    self.events = [[RZFilteredCollectionList alloc] initWithSourceList:fetchedList predicate:nil filterOutEmptySections:YES];
    self.searchEvents = [[RZFilteredCollectionList alloc] initWithSourceList:self.events predicate:nil filterOutEmptySections:YES];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    STKEventGroupType type = [userDefaults integerForKey:kSTKUserDefaultsKeyEventGroupType];
    if (type == STKEventGroupTypeUnknown) {
        type = STKEventGroupTypeCollege;
    }

    STKEventGroupDivision division = [userDefaults integerForKey:kSTKUserDefaultsKeyEventGroupDivision];
    if (division == STKEventGroupDivisionUnknown) {
        division = STKEventGroupDivisionMens;
    }

    self.type = type;
    self.division = division;
    self.divisions = [STKEventGroup divisionsForType:self.type];

    
    [self updateEvents];
}

- (void)setupDataSourceWithTableView:(UITableView *)tableView delegate:(id<RZCollectionListTableViewDataSourceDelegate>)delegate {
    self.dataSource = [[RZCollectionListTableViewDataSource alloc] initWithTableView:tableView collectionList:self.searchEvents delegate:delegate];
    self.dataSource.animateTableChanges = NO;
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource.collectionList objectAtIndexPath:indexPath];
}

- (id)sectionObjectForSection:(NSUInteger)section {
    STKEvent *event = [self.searchEvents.sections[section] objects].firstObject;

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

    STKEvent *event = [self.searchEvents.listObjects filteredArrayUsingPredicate:weekPredicate].firstObject;
    return [self.searchEvents indexPathForObject:event].section;
}

- (void)searchForText:(NSString *)text {
    NSPredicate *predicate;

    if (text.length > 0) {
        predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", RZDB_KP(STKEvent, name), text];
    }
    else {
        predicate = nil;
    }

    self.searchEvents.predicate = predicate;
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

- (NSIndexPath *)indexPathForSelectedType {
    NSInteger row = (NSInteger)[self.types indexOfObject:@(self.type)];
    if (row == NSNotFound) {
        row = 0;
    }

    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSIndexPath *)indexPathForSelectedDivision {
    NSInteger row = (NSInteger)[self.divisions indexOfObject:@(self.division)];
    if (row == NSNotFound) {
        row = 0;
    }

    return [NSIndexPath indexPathForRow:row inSection:1];
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;

    if (component == 0) {
        STKEventGroupType type = [self.types[(NSUInteger)row] integerValue];
        title = [STKEventGroup titleForType:type];
    }
    else {
        STKEventGroupDivision division = [self.divisions[(NSUInteger)row] integerValue];
        title = [STKEventGroup titleForDivision:division];
    }

    return title;
}

- (void)updateEvents {
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"ANY groups.type == %@", @(self.type)];
    NSPredicate *divisionPredicate = [NSPredicate predicateWithFormat:@"ANY groups.division == %@", @(self.division)];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[typePredicate, divisionPredicate]];

    self.events.predicate = predicate;

    [self updateFilteredText];
}

- (void)updateFilteredText {
    NSString *typeTitle = [STKEventGroup titleForType:self.type];
    NSString *divisionTitle = [STKEventGroup titleForDivision:self.division];

    self.title = [NSString stringWithFormat:@"%@ %@", typeTitle, divisionTitle];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger count = 0;

    if (component == 0) {
        count = self.types.count;
    }
    else {
        count = self.divisions.count;
    }

    return (NSInteger)count;
}

#pragma mark - Picker View Delegate

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//
//    if (!view) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.font = [UIFont stk_eventsFilterTitleFont];
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//
//        view = label;
//    }
//
//    if ([view isKindOfClass:[UILabel class]]) {
//        UILabel *label = (UILabel *)view;
//        label.text = [self titleForRow:row forComponent:component];
//    }
//
//    return view;
//}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [self titleForRow:row forComponent:component];
    NSDictionary *attributes = [STKAttributes stk_eventsFilterTitleAttributes];

    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.type = [self.types[(NSUInteger)row] integerValue];

        self.divisions = [STKEventGroup divisionsForType:self.type];

        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.division = [self.divisions.firstObject integerValue];
    }
    else {
        self.division = [self.divisions[(NSUInteger)row] integerValue];
    }

    [self updateEvents];
}

@end
