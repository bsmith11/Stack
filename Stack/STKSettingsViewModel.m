//
//  STKSettingsViewModel.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSettingsViewModel.h"

#import "STKSettingsItem.h"
#import "STKSettingsHeader.h"

#import "STKCollectionListTableViewDataSource.h"
#import "STKNotificationsManager.h"
#import "STKAnalyticsManager.h"

#import <RZCollectionList/RZCollectionList.h>

static NSString * const kSTKSettingsViewModelHeaderTitleGeneral = @"General";
static NSString * const kSTKSettingsViewModelHeaderTitleNotificationsEnabled = @"Notifications";
static NSString * const kSTKSettingsViewModelHeaderTitleNotificationsDisabled = @"Notifications disabled, enable in Settings";

@interface STKSettingsViewModel ()

@property (strong, nonatomic) STKCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZCompositeCollectionList *items;
@property (strong, nonatomic) RZArrayCollectionList *generalList;
@property (strong, nonatomic) RZArrayCollectionList *notificationsList;

@end

@implementation STKSettingsViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupItems];
        [self setupObservers];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupItems {
    STKSettingsHeader *generalHeader = [STKSettingsHeader headerWithTitle:kSTKSettingsViewModelHeaderTitleGeneral];

    STKSettingsItem *feedbackItem = [STKSettingsItem itemWithTitle:@"Feedback"
                                                             image:[UIImage imageNamed:@"Mail Icon"]
                                                            target:self
                                                            action:@selector(didTapFeedbackItem)
                                                              type:STKSettingsItemTypeDisclosureIndicator];

    NSArray *generalItems = @[generalHeader, feedbackItem];
    self.generalList = [[RZArrayCollectionList alloc] initWithArray:generalItems sectionNameKeyPath:nil];

    BOOL notificationsEnabled = [[STKNotificationsManager sharedInstance] notificationsPermissionEnabled];

    NSString *headerTitle = notificationsEnabled ? kSTKSettingsViewModelHeaderTitleNotificationsEnabled : kSTKSettingsViewModelHeaderTitleNotificationsDisabled;
    STKSettingsHeader *notificationsHeader = [STKSettingsHeader headerWithTitle:headerTitle];

    NSMutableArray *notificationItems = [NSMutableArray arrayWithObject:notificationsHeader];

    NSArray *sourceTypes = [STKSource sourcesWithNotificationsAvailable];
    for (NSNumber *sourceTypeNumber in sourceTypes) {
        STKSourceType sourceType = sourceTypeNumber.integerValue;
        STKSettingsItem *item = [STKSettingsItem itemWithTitle:[STKSource nameForType:sourceType]
                                                         image:[UIImage imageNamed:[STKSource imageNameForType:sourceType]]
                                                        target:self
                                                        action:@selector(didSwitchNotificationsItem:value:)
                                                          type:STKSettingsItemTypeSwitch];
        item.value = [[STKNotificationsManager sharedInstance] notificationsEnabledForSourceType:sourceType];
        item.enabled = notificationsEnabled;

        [notificationItems addObject:item];
    }

    self.notificationsList = [[RZArrayCollectionList alloc] initWithArray:notificationItems sectionNameKeyPath:nil];
    self.items = [[RZCompositeCollectionList alloc] initWithSourceLists:@[self.generalList, self.notificationsList]];
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsPermissionDidChangeNotification:) name:kSTKNotificationsPermissionDidChangeNotification object:nil];
}

- (void)setupCollectionListDataSourceWithTableView:(ASTableView *)tableView delegate:(id<STKCollectionListTableViewDelegate>)delegate {
    self.dataSource = [[STKCollectionListTableViewDataSource alloc] initWithTableView:tableView
                                                                       collectionList:self.items
                                                                             delegate:delegate];
}

#pragma mark - Actions

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.items objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return [self.items indexPathForObject:object];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];

    if ([object isKindOfClass:[STKSettingsItem class]]) {
        STKSettingsItem *item = (STKSettingsItem *)object;

        if (item.type == STKSettingsItemTypeDisclosureIndicator) {
            [item performAction];
        }
    }
}

- (void)didTapFeedbackItem {
    [STKAnalyticsManager logEventDidClickFeedback];

    if ([self.delegate respondsToSelector:@selector(presentMailViewController)]) {
        [self.delegate presentMailViewController];
    }
}

- (void)didSwitchNotificationsItem:(STKSettingsItem *)item value:(id)value {
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *status = (NSNumber *)value;
        STKSourceType sourceType = [STKSource sourceTypeForName:item.title];

        [STKAnalyticsManager logEventDidEnableNotifications:status.boolValue sourceType:sourceType];
        [[STKNotificationsManager sharedInstance] setNotificationsEnabled:status.boolValue sourceType:sourceType];
    }
}

- (void)notificationsPermissionDidChangeNotification:(NSNotification *)notification {
    BOOL enabled = [notification.userInfo[kSTKNotificationsPermissionDidChangeNotificationKeyEnabled] boolValue];

    for (id object in self.notificationsList.listObjects) {
        if ([object isKindOfClass:[STKSettingsItem class]]) {
            STKSettingsItem *item = (STKSettingsItem *)object;
            item.enabled = enabled;
        }
        else if ([object isKindOfClass:[STKSettingsHeader class]]) {
            STKSettingsHeader *header = (STKSettingsHeader *)object;
            header.title = enabled ? kSTKSettingsViewModelHeaderTitleNotificationsEnabled : kSTKSettingsViewModelHeaderTitleNotificationsDisabled;
        }
    }

    NSUInteger index = [self.items.sourceLists indexOfObject:self.notificationsList];
    if (index != NSNotFound) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [self.dataSource.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
