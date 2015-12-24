//
//  STKNotificationsManager.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKNotificationsManager.h"

#import <Parse/Parse.h>

NSString * const kSTKNotificationsPermissionDidChangeNotification = @"com.bradsmith.stack.notifications.permissionDidChangeNotification";
NSString * const kSTKNotificationsPermissionDidChangeNotificationKeyEnabled = @"enabled";

@interface STKNotificationsManager ()

@property (strong, nonatomic) NSDictionary *channels;

@property (copy, nonatomic) STKNotificationsPermissionBlock notificationsPermissionBlock;

@property (assign, nonatomic) BOOL previousPermissionStatus;

@end

@implementation STKNotificationsManager

#pragma mark - Lifecycle

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[STKNotificationsManager alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        self.channels = @{@(STKSourceTypeSkyd):@"skyd_magazine",
                          @(STKSourceTypeBamaSecs):@"bama_secs",
                          @(STKSourceTypeUltiworld):@"ultiworld",
                          @(STKSourceTypeAUDL):@"audl",
                          @(STKSourceTypeMLU):@"mlu"};
    }

    return self;
}

#pragma mark - Actions

- (BOOL)notificationsEnabledForSourceType:(STKSourceType)sourceType {
    NSString *channel = self.channels[@(sourceType)];

    return [[PFInstallation currentInstallation].channels containsObject:channel];
}

- (void)setNotificationsEnabled:(BOOL)enabled sourceType:(STKSourceType)sourceType {
    NSString *channel = self.channels[@(sourceType)];
    PFInstallation *installation = [PFInstallation currentInstallation];

    if (enabled) {
        [installation addUniqueObject:channel forKey:@"channels"];
    }
    else {
        [installation removeObject:channel forKey:@"channels"];
    }

    [installation saveInBackground];
}

- (BOOL)notificationsPermissionEnabled {
    UIUserNotificationSettings *notificationsSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];

    return (notificationsSettings.types == UIUserNotificationTypeAlert);
}

- (void)requestNotificationsPermissionWithCompletion:(STKNotificationsPermissionBlock)completion {
    self.notificationsPermissionBlock = completion;

    UIUserNotificationType types = UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];

    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    BOOL granted = (notificationSettings.types == UIUserNotificationTypeAlert);

    if (self.notificationsPermissionBlock) {
        self.notificationsPermissionBlock(granted);
        self.notificationsPermissionBlock = nil;
    }
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];

    NSArray *channels = [self.channels allValues];
    [installation addUniqueObjectsFromArray:channels forKey:@"channels"];
    [installation saveInBackground];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register for remote notifications with error: %@", error);
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {

}

- (void)applicationWillEnterForeground {
    NSLog(@"Will Enter Foreground");
    BOOL enabled = [self notificationsPermissionEnabled];

    if (self.previousPermissionStatus != enabled) {
        NSDictionary *userInfo = @{kSTKNotificationsPermissionDidChangeNotificationKeyEnabled:@(enabled)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kSTKNotificationsPermissionDidChangeNotification object:nil userInfo:userInfo];
    }
}

- (void)applicationDidEnterBackground {
    NSLog(@"Did Enter Background");
    self.previousPermissionStatus = [self notificationsPermissionEnabled];
}

@end
