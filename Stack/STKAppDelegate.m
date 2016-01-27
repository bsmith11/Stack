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
#import "STKNotificationsManager.h"
#import "STKAnalyticsManager.h"
#import "STKContentManager.h"
#import "STKPost.h"

#import <Keys/StackKeys.h>
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation STKAppDelegate

#pragma mark - Application Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    StackKeys *keys = [[StackKeys alloc] init];

    [ParseCrashReporting enable];
    [Parse setApplicationId:keys.parseApplicationID
                  clientKey:keys.parseClientKey];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    [STKCoreDataStack configureStack];

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

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
//#ifdef DEBUG
//    UILocalNotification *fetchNotification = [[UILocalNotification alloc] init];
//    fetchNotification.alertTitle = @"Background Fetch";
//    fetchNotification.alertBody = @"Performing background fetch...";
//
//    [application scheduleLocalNotification:fetchNotification];
//#endif

    NSArray *fetchedPosts = [STKPost fetchPostsBeforePost:nil
                                                   author:nil
                                               sourceType:-1];

    [STKContentManager downloadPostsBeforePosts:nil completion:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        UIBackgroundFetchResult result = UIBackgroundFetchResultNoData;

        for (STKPost *post in posts) {
            if (![fetchedPosts containsObject:post]) {
                result = UIBackgroundFetchResultNewData;
                break;
            }
        }

//#ifdef DEBUG
//        UILocalNotification *resultNotification = [[UILocalNotification alloc] init];
//        resultNotification.alertTitle = @"Background Fetch";
//        NSString *resultString = (result == UIBackgroundFetchResultNewData) ? @"New data" : @"No data";
//        resultNotification.alertBody = [NSString stringWithFormat:@"%@ fetched", resultString];
//
//        [application scheduleLocalNotification:resultNotification];
//#endif

        completionHandler(result);
    }];
}

@end
