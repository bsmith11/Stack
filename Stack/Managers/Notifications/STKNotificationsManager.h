//
//  STKNotificationsManager.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

OBJC_EXTERN NSString * const kSTKNotificationsPermissionDidChangeNotification;
OBJC_EXTERN NSString * const kSTKNotificationsPermissionDidChangeNotificationKeyEnabled;

typedef void (^STKNotificationsPermissionBlock)(BOOL granted);

@interface STKNotificationsManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)notificationsEnabledForSourceType:(STKSourceType)sourceType;
- (void)setNotificationsEnabled:(BOOL)enabled sourceType:(STKSourceType)sourceType;

- (BOOL)notificationsPermissionEnabled;
- (void)requestNotificationsPermissionWithCompletion:(STKNotificationsPermissionBlock)completion;
- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)applicationWillEnterForeground;
- (void)applicationDidEnterBackground;

@end
