//
//  STKAppDelegate.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15
//  Copyright (c) 2015 Brad Smith. All rights reserved.
//

#import "STKAppDelegate.h"

#import "STKRootViewController.h"

#import "STKCoreDataStack.h"
#import "STKSource.h"
#import "STKNotificationsManager.h"
#import "STKAnalyticsManager.h"
#import "STKContentManager.h"

#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation STKAppDelegate

#pragma mark - Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    [STKCoreDataStack configureStack];

    [application setMinimumBackgroundFetchInterval:20000.0f];

    STKRootViewController *rootViewController = [[STKRootViewController alloc] init];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:rootViewController];
    [self.window setBackgroundColor:[UIColor whiteColor]];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[STKNotificationsManager sharedInstance] didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[STKNotificationsManager sharedInstance] didReceiveLocalNotification:notification];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[STKNotificationsManager sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[STKNotificationsManager sharedInstance] didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[STKNotificationsManager sharedInstance] didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [STKAnalyticsManager logEventApplicationWillEnterForeground];
    [[STKNotificationsManager sharedInstance] applicationWillEnterForeground];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [STKAnalyticsManager logEventApplicationDidEnterBackground];
    [[STKNotificationsManager sharedInstance] applicationDidEnterBackground];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//TODO: Debug notification, should be removed before release
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertTitle = @"Background Fetch";
    notification.alertBody = @"Performing background fetch...";

    [application scheduleLocalNotification:notification];

    [STKContentManager downloadPostsBeforePosts:nil completion:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        completionHandler(UIBackgroundFetchResultNewData);
    }];
}

@end
