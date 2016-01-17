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
#import "STKAttributes.h"
#import "UIColor+STKStyle.h"

#import <RZCollectionList/RZCollectionList.h>

static NSString * const kSTKSettingsViewModelNotificationsObjectUpdateNotification = @"com.bradsmith.stack.settings.notificationsObjectUpdateNotification";
static NSString * const kSTKSettingsViewModelHeaderTitleGeneral = @"General";
static NSString * const kSTKSettingsViewModelHeaderTitleNotificationsEnabled = @"Notifications";
static NSString * const kSTKSettingsViewModelHeaderTitleNotificationsDisabled = @"Notifications disabled, enable in Settings";

@interface STKSettingsViewModel ()

@property (strong, nonatomic) STKCollectionListTableViewDataSource *dataSource;
@property (strong, nonatomic) RZCompositeCollectionList *items;
@property (strong, nonatomic) RZArrayCollectionList *generalList;
@property (strong, nonatomic) RZArrayCollectionList *notificationsList;

@property (copy, nonatomic) NSAttributedString *headerTitleNotificationsEnabled;
@property (copy, nonatomic) NSAttributedString *headerTitleNotificationsDisabled;

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
    NSAttributedString *generalTitle = [[NSAttributedString alloc] initWithString:kSTKSettingsViewModelHeaderTitleGeneral
                                                                       attributes:[STKAttributes stk_settingsHeaderTitleAttributes]];
    STKSettingsHeader *generalHeader = [STKSettingsHeader headerWithTitle:generalTitle];

    STKSettingsItem *feedbackItem = [STKSettingsItem itemWithTitle:@"Send Feedback"
                                                             image:[UIImage imageNamed:@"Mail Icon"]
                                                              type:STKSettingsItemTypeDetail];
    [feedbackItem addTarget:self action:@selector(didTapFeedbackItem) forEvent:STKSettingsItemEventSelection];
    [feedbackItem addTarget:self action:@selector(didTapFeedbackItemAccessory) forEvent:STKSettingsItemEventAccessory];

    STKSettingsItem *clearCacheItem = [STKSettingsItem itemWithTitle:@"Clear Cache"
                                                               image:[UIImage imageNamed:@"Delete Icon"]
                                                                type:STKSettingsItemTypeDetail];
    [clearCacheItem addTarget:self action:@selector(didTapClearCacheItem) forEvent:STKSettingsItemEventSelection];
    [clearCacheItem addTarget:self action:@selector(didTapClearCacheItemAccessory) forEvent:STKSettingsItemEventAccessory];

    NSArray *generalItems = @[generalHeader, feedbackItem, clearCacheItem];
    self.generalList = [[RZArrayCollectionList alloc] initWithArray:generalItems sectionNameKeyPath:nil];

    self.headerTitleNotificationsEnabled = [[NSAttributedString alloc] initWithString:kSTKSettingsViewModelHeaderTitleNotificationsEnabled
                                                                           attributes:[STKAttributes stk_settingsHeaderTitleAttributes]];

    NSMutableAttributedString *headerTitleNotificationsDisabled = [[NSMutableAttributedString alloc] initWithString:kSTKSettingsViewModelHeaderTitleNotificationsDisabled
                                                                                                         attributes:[STKAttributes stk_settingsHeaderTitleAttributes]];
    NSRange range = [headerTitleNotificationsDisabled.string rangeOfString:@"Settings"];
    [headerTitleNotificationsDisabled addAttribute:@"STKLink" value:UIApplicationOpenSettingsURLString range:range];
    [headerTitleNotificationsDisabled addAttribute:NSForegroundColorAttributeName value:[UIColor stk_twitterColor] range:range];
    [headerTitleNotificationsDisabled addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    self.headerTitleNotificationsDisabled = headerTitleNotificationsDisabled;

    BOOL notificationsEnabled = [[STKNotificationsManager sharedInstance] notificationsPermissionEnabled];
    NSAttributedString *notificationsTitle = notificationsEnabled ? self.headerTitleNotificationsEnabled : self.headerTitleNotificationsDisabled;

    STKSettingsHeader *notificationsHeader = [STKSettingsHeader headerWithTitle:notificationsTitle];

    NSMutableArray *notificationItems = [NSMutableArray arrayWithObject:notificationsHeader];

    NSArray *sourceTypes = [STKSource sourcesWithNotificationsAvailable];
    for (NSNumber *sourceTypeNumber in sourceTypes) {
        STKSourceType sourceType = sourceTypeNumber.integerValue;
        STKSettingsItem *item = [STKSettingsItem itemWithTitle:[STKSource nameForType:sourceType]
                                                         image:[UIImage imageNamed:[STKSource imageNameForType:sourceType]]
                                                          type:STKSettingsItemTypeSwitch];
        [item addTarget:self action:@selector(didSwitchNotificationsItem:) forEvent:STKSettingsItemEventSwitch];
        item.value = [[STKNotificationsManager sharedInstance] notificationsEnabledForSourceType:sourceType];
        item.enabled = notificationsEnabled;

        [notificationItems addObject:item];
    }

    self.notificationsList = [[RZArrayCollectionList alloc] initWithArray:notificationItems sectionNameKeyPath:nil];
    self.notificationsList.objectUpdateNotifications = @[kSTKSettingsViewModelNotificationsObjectUpdateNotification];
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

        [item performActionForEvent:STKSettingsItemEventSelection];
    }
}

- (void)didTapSwitchForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];

    if ([object isKindOfClass:[STKSettingsItem class]]) {
        STKSettingsItem *item = (STKSettingsItem *)object;

        [item performActionForEvent:STKSettingsItemEventSwitch];
    }
}

- (void)didTapAccessoryForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];

    if ([object isKindOfClass:[STKSettingsItem class]]) {
        STKSettingsItem *item = (STKSettingsItem *)object;

        [item performActionForEvent:STKSettingsItemEventAccessory];
    }
}

- (void)didTapFeedbackItem {
    [STKAnalyticsManager logEventDidClickFeedback];

    if ([self.delegate respondsToSelector:@selector(presentMailViewController)]) {
        [self.delegate presentMailViewController];
    }
}

- (void)didTapFeedbackItemAccessory {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Feedback" message:@"Info Here" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];

    if ([self.delegate respondsToSelector:@selector(presentAlertController:)]) {
        [self.delegate presentAlertController:alertController];
    }
}

- (void)didTapClearCacheItem {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear Cache" message:@"Message Here" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *denyAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:confirmAction];
    [alertController addAction:denyAction];

    if ([self.delegate respondsToSelector:@selector(presentAlertController:)]) {
        [self.delegate presentAlertController:alertController];
    }
}

- (void)didTapClearCacheItemAccessory {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Clear Cache" message:@"Info Here" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];

    if ([self.delegate respondsToSelector:@selector(presentAlertController:)]) {
        [self.delegate presentAlertController:alertController];
    }
}

- (void)didSwitchNotificationsItem:(STKSettingsItem *)item {
    item.value = !item.value;

    STKSourceType sourceType = [STKSource sourceTypeForName:item.title];

    [STKAnalyticsManager logEventDidEnableNotifications:item.value sourceType:sourceType];
    [[STKNotificationsManager sharedInstance] setNotificationsEnabled:item.value sourceType:sourceType];
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
            header.title = enabled ? self.headerTitleNotificationsEnabled : self.headerTitleNotificationsDisabled;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:kSTKSettingsViewModelNotificationsObjectUpdateNotification object:object];
    }
}

@end
