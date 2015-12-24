//
//  STKAnalyticsManager.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAnalyticsManager.h"

#import "STKPost.h"
#import "STKAuthor.h"
//#import "STKTwitterUser.h"
//#import "STKTweet.h"

//#import <TwitterKit/TWTRUser.h>
#import <Parse/Parse.h>
#import <RZUtils/RZCommonUtils.h>

#define STKBooleanToString(x) (x ? @"YES" : @"NO")

@implementation STKAnalyticsManager

#pragma mark - Session

+ (void)logEventApplicationWillEnterForeground {
    [PFAnalytics trackEvent:@"applicationWillEnterForeground"];
}

+ (void)logEventApplicationDidEnterBackground {
    [PFAnalytics trackEvent:@"applicationDidEnterBackground"];
}

+ (void)logEventSessionDidStart {

}

+ (void)logEventSessionDidEnd {

}

#pragma mark - Feed

+ (void)logEventDidClickFeedTab {
    [PFAnalytics trackEvent:@"didClickFeedTab"];
}

+ (void)logEventDidClickPostFromFeed:(STKPost *)post {
    [PFAnalytics trackEvent:@"didClickPostFromFeed" dimensions:post.analyticsInfo];
}

+ (void)logEventDidClickFeedWithSourceType:(STKSourceType)sourceType {
    NSDictionary *dimensions = @{@"sourceName":[STKSource nameForType:sourceType]};

    [PFAnalytics trackEvent:@"didClickFeedWithSourceType" dimensions:dimensions];
}

+ (void)logEventDidClickPostSearch {
    [PFAnalytics trackEvent:@"didClickPostSearch"];
}

+ (void)logEventDidClickPostFromSearch:(STKPost *)post {
    [PFAnalytics trackEvent:@"didClickPostFromSearch" dimensions:post.analyticsInfo];
}

#pragma mark - Twitter

//+ (void)logEventDidClickTwitterTab {
//    [PFAnalytics trackEvent:@"didClickTwitterTab"];
//}
//
//+ (void)logEventDidClickTweetMedia:(STKTweet *)tweet {
//    [PFAnalytics trackEvent:@"didClickTweetMedia" dimensions:tweet.analyticsInfo];
//}
//
//+ (void)logEventDidClickTwitterSearch {
//    [PFAnalytics trackEvent:@"didClickTwitterSearch"];
//}
//
//+ (void)logEventDidAddTwitterUser:(TWTRUser *)user {
//    NSDictionary *dimensions = @{@"userID":RZNilToEmptyString(user.userID),
//                                 @"screenName":RZNilToEmptyString(user.screenName)};
//
//    [PFAnalytics trackEvent:@"didAddTwitterUser" dimensions:dimensions];
//}
//
//+ (void)logEventDidRemoveTwitterUser:(STKTwitterUser *)user {
//    [PFAnalytics trackEvent:@"didRemoveTwitterUser" dimensions:user.analyticsInfo];
//}
//
//+ (void)logEventDidClickLoginTwitter {
//    [PFAnalytics trackEvent:@"didClickLoginTwitter"];
//}
//
//+ (void)logEventDidEnableTwitter:(BOOL)enabled {
//    NSDictionary *dimensions = @{@"enabled":STKBooleanToString(enabled)};
//
//    [PFAnalytics trackEvent:@"didEnableTwitter" dimensions:dimensions];
//}
//
//+ (void)logEventDidLoginTwitterCompleted:(BOOL)completed {
//    NSDictionary *dimensions = @{@"completed":STKBooleanToString(completed)};
//
//    [PFAnalytics trackEvent:@"didLoginTwitterCompleted" dimensions:dimensions];
//}
//
//+ (void)logEventDidLogoutTwitter {
//    [PFAnalytics trackEvent:@"didLogoutTwitter"];
//}

#pragma mark - Bookmarks

+ (void)logEventDidClickBookmarksTab {
    [PFAnalytics trackEvent:@"didClickBookmarksTab"];
}

+ (void)logEventDidClickPostFromBookmarks:(STKPost *)post {
    [PFAnalytics trackEvent:@"didClickPostFromBooksmarks" dimensions:post.analyticsInfo];
}

#pragma mark - Settings

+ (void)logEventDidClickSettingsTab {
    [PFAnalytics trackEvent:@"didClickSettingsTab"];
}

+ (void)logEventDidClickFeedback {
    [PFAnalytics trackEvent:@"didClickFeedback"];
}

+ (void)logEventDidCompleteFeedback:(BOOL)complete {
    NSDictionary *dimensions = @{@"completed":STKBooleanToString(complete)};

    [PFAnalytics trackEvent:@"didCompleteFeedback" dimensions:dimensions];
}

#pragma mark - Post

+ (void)logEventDidBookmarkPost:(STKPost *)post enabled:(BOOL)enabled {
    NSMutableDictionary *dimensions = [post.analyticsInfo mutableCopy];
    dimensions[@"enabled"] = STKBooleanToString(enabled);

    [PFAnalytics trackEvent:@"didBookmarkPost" dimensions:dimensions];
}

+ (void)logEventDidClickAuthor:(STKAuthor *)author fromPost:(STKPost *)post {
    NSMutableDictionary *dimensions = [author.analyticsInfo mutableCopy];
    [dimensions addEntriesFromDictionary:post.analyticsInfo];

    [PFAnalytics trackEvent:@"didClickAuthorFromPost" dimensions:dimensions];
}

+ (void)logEventDidClickShareForPost:(STKPost *)post {
    [PFAnalytics trackEvent:@"didClickShareForPost" dimensions:post.analyticsInfo];
}

+ (void)logEventDidCancelShareForPost:(STKPost *)post {
    [PFAnalytics trackEvent:@"didCancelShareForPost" dimensions:post.analyticsInfo];
}

+ (void)logEventDidSharePost:(STKPost *)post activityType:(NSString *)activityType {
    NSMutableDictionary *dimensions = [post.analyticsInfo mutableCopy];
    dimensions[@"shareType"] = RZNilToEmptyString(activityType);

    [PFAnalytics trackEvent:@"didSharePost" dimensions:dimensions];
}

+ (void)logEventDidClickLink:(NSURL *)link fromPost:(STKPost *)post {
    NSMutableDictionary *dimensions = [post.analyticsInfo mutableCopy];
    dimensions[@"link"] = RZNilToEmptyString(link.absoluteString);

    [PFAnalytics trackEvent:@"didClickLinkFromPost" dimensions:nil];
}

+ (void)logEventDidClickMediaWithURL:(NSURL *)URL fromPost:(STKPost *)post {
    NSMutableDictionary *dimensions = [post.analyticsInfo mutableCopy];
    dimensions[@"mediaURL"] = RZNilToEmptyString(URL.absoluteString);

    [PFAnalytics trackEvent:@"didClickMediaWithURLFromPost" dimensions:dimensions];
}

#pragma mark - Author

+ (void)logEventDidClickPost:(STKPost *)post fromAuthor:(STKAuthor *)author {
    NSMutableDictionary *dimensions = [post.analyticsInfo mutableCopy];
    [dimensions addEntriesFromDictionary:author.analyticsInfo];

    [PFAnalytics trackEvent:@"didClickPostFromAuthor" dimensions:dimensions];
}

#pragma mark - Notifications

+ (void)logEventDidAcceptNotificationsPrettyPlease {
    [PFAnalytics trackEvent:@"didAcceptNotificationsPrettyPlease"];
}

+ (void)logEventDidSkipNotificationsPrettyPlease {
    [PFAnalytics trackEvent:@"didSkipNotificationsPrettyPlease"];
}

+ (void)logEventDidEnableNotificationsPermission:(BOOL)enabled {
    NSDictionary *dimensions = @{@"enabled":STKBooleanToString(enabled)};

    [PFAnalytics trackEvent:@"didEnableNotificationsPermission" dimensions:dimensions];
}

+ (void)logEventDidEnableNotifications:(BOOL)enabled sourceType:(STKSourceType)sourceType {
    NSDictionary *dimensions = @{@"sourceName":[STKSource nameForType:sourceType]};
    NSMutableDictionary *mutableDimensions = [dimensions mutableCopy];
    mutableDimensions[@"enabled"] = STKBooleanToString(enabled);

    [PFAnalytics trackEvent:@"didEnableNotificationsForSource" dimensions:mutableDimensions];
}

#pragma mark - Errors

+ (void)logEventDidFailRequest:(NSURLRequest *)request error:(NSError *)error {
    NSDictionary *dimensions = @{@"requestURL":RZNilToEmptyString(request.URL.absoluteString),
                                 @"errorCode":@(error.code).stringValue,
                                 @"localizedDescription":RZNilToEmptyString(error.localizedDescription)};

    [PFAnalytics trackEvent:@"didFailRequestWithError" dimensions:dimensions];
}

@end
