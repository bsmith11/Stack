//
//  STKAnalyticsManager.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@class STKPost, STKAuthor;

@interface STKAnalyticsManager : NSObject

#pragma mark - Session

+ (void)logEventApplicationWillEnterForeground;
+ (void)logEventApplicationDidEnterBackground;
+ (void)logEventSessionDidStart;
+ (void)logEventSessionDidEnd;

#pragma mark - Feed

+ (void)logEventDidClickFeedTab;
+ (void)logEventDidClickPostFromFeed:(STKPost *)post;
+ (void)logEventDidClickFeedWithSourceType:(STKSourceType)sourceType;
+ (void)logEventDidClickPostSearch;
+ (void)logEventDidClickPostFromSearch:(STKPost *)post;

#pragma mark - Twitter

//+ (void)logEventDidClickTwitterTab;
//+ (void)logEventDidClickTweetMedia:(STKTweet *)tweet;
//+ (void)logEventDidClickTwitterSearch;
//+ (void)logEventDidAddTwitterUser:(TWTRUser *)user;
//+ (void)logEventDidRemoveTwitterUser:(STKTwitterUser *)user;
//+ (void)logEventDidClickLoginTwitter;
//+ (void)logEventDidEnableTwitter:(BOOL)enabled;
//+ (void)logEventDidLoginTwitterCompleted:(BOOL)completed;
//+ (void)logEventDidLogoutTwitter;

#pragma mark - Bookmarks

+ (void)logEventDidClickBookmarksTab;
+ (void)logEventDidClickPostFromBookmarks:(STKPost *)post;

#pragma mark - Settings

+ (void)logEventDidClickSettingsTab;
+ (void)logEventDidClickFeedback;
+ (void)logEventDidCompleteFeedback:(BOOL)complete;

#pragma mark - Post

+ (void)logEventDidBookmarkPost:(STKPost *)post enabled:(BOOL)enabled;
+ (void)logEventDidClickAuthor:(STKAuthor *)author fromPost:(STKPost *)post;
+ (void)logEventDidClickShareForPost:(STKPost *)post;
+ (void)logEventDidCancelShareForPost:(STKPost *)post;
+ (void)logEventDidSharePost:(STKPost *)post activityType:(NSString *)activityType;
+ (void)logEventDidClickLink:(NSURL *)link fromPost:(STKPost *)post;
+ (void)logEventDidClickMediaWithURL:(NSURL *)URL fromPost:(STKPost *)post;

#pragma mark - Author

+ (void)logEventDidClickPost:(STKPost *)post fromAuthor:(STKAuthor *)author;

#pragma mark - Notifications

+ (void)logEventDidAcceptNotificationsPrettyPlease;
+ (void)logEventDidSkipNotificationsPrettyPlease;
+ (void)logEventDidEnableNotificationsPermission:(BOOL)enabled;
+ (void)logEventDidEnableNotifications:(BOOL)enabled sourceType:(STKSourceType)sourceType;

#pragma mark - Errors

+ (void)logEventDidFailRequest:(NSURLRequest *)request error:(NSError *)error;

@end
