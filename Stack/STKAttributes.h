//
//  STKAttributes.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@interface STKAttributes : NSObject

+ (NSDictionary *)stk_navigationBarTitleAttributes;

+ (NSDictionary *)stk_errorTitleAttributes;
+ (NSDictionary *)stk_errorMessageAttributes;

+ (NSDictionary *)stk_welcomeTitleAttributes;
+ (NSDictionary *)stk_onboardingTitleAttributes;
+ (NSDictionary *)stk_onboardingMessageAttributes;
+ (NSDictionary *)stk_onboardingActionAttributes;

+ (NSDictionary *)stk_postNodeTitleAttributes;
+ (NSDictionary *)stk_postNodeDateAttributes;

+ (NSDictionary *)stk_postAuthorAttributes;
+ (NSDictionary *)stk_postDateAttributes;
+ (NSDictionary *)stk_postTitleAttributes;
+ (NSDictionary *)stk_postBodyAttributes;
+ (NSDictionary *)stk_postCommentTitleAttributes;

+ (NSDictionary *)stk_commentNodeAuthorAttributes;
+ (NSDictionary *)stk_commentNodeDateAttributes;
+ (NSDictionary *)stk_commentNodeBodyAttributes;

+ (NSDictionary *)stk_authorNameAttributes;
+ (NSDictionary *)stk_authorSummaryAttributes;

+ (NSDictionary *)stk_sourceNameAttributes;
+ (NSDictionary *)stk_sourceSummaryAttributes;

+ (NSDictionary *)stk_unavailableTitleAttributes;
+ (NSDictionary *)stk_unavailableMessageAttributes;
+ (NSDictionary *)stk_unavailableActionAttributes;

+ (NSDictionary *)stk_emptyStateTitleAttributes;
+ (NSDictionary *)stk_emptyStateMessageAttributes;
+ (NSDictionary *)stk_emptyStateActionAttributes;

+ (NSDictionary *)stk_filterSourceAttributes;

+ (NSDictionary *)stk_searchTextFieldPlaceholderAttributes;

+ (NSDictionary *)stk_tweetRetweetAttributes;
+ (NSDictionary *)stk_tweetAuthorAttributes;
+ (NSDictionary *)stk_tweetDetailAttributes;
+ (NSDictionary *)stk_tweetBodyAttributes;

+ (NSDictionary *)stk_twitterUserNameAttributes;

+ (NSDictionary *)stk_settingsItemTitleAttributes;
+ (NSDictionary *)stk_settingsHeaderTitleAttributes;

@end
