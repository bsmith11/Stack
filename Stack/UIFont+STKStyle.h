//
//  UIFont+STKStyle.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

OBJC_EXTERN CGFloat const kSTKDefaultFontSize;
OBJC_EXTERN CGFloat const kSTKDefaultFontLineSpacing;

@interface UIFont (STKStyle)

+ (UIFont *)stk_navigationBarTitleFont;

+ (UIFont *)stk_errorTitleFont;
+ (UIFont *)stk_errorMessageFont;

+ (UIFont *)stk_welcomeTitleFont;
+ (UIFont *)stk_onboardingTitleFont;
+ (UIFont *)stk_onboardingMessageFont;
+ (UIFont *)stk_onboardingActionFont;

+ (UIFont *)stk_postNodeTitleFont;
+ (UIFont *)stk_postNodeDateFont;

+ (UIFont *)stk_postAuthorFont;
+ (UIFont *)stk_postDateFont;
+ (UIFont *)stk_postTitleFont;
+ (UIFont *)stk_postBodyFont;
+ (UIFont *)stk_postCommentTitleFont;

+ (UIFont *)stk_commentNodeAuthorFont;
+ (UIFont *)stk_commentNodeDateFont;
+ (UIFont *)stk_commentNodeBodyFont;

+ (UIFont *)stk_authorNameFont;
+ (UIFont *)stk_authorSummaryFont;

+ (UIFont *)stk_sourceNameFont;
+ (UIFont *)stk_sourceSummaryFont;

+ (UIFont *)stk_emptyStateTitleFont;
+ (UIFont *)stk_emptyStateMessageFont;
+ (UIFont *)stk_emptyStateActionFont;

+ (UIFont *)stk_filterSourceFont;

+ (UIFont *)stk_searchTextFieldFont;

+ (UIFont *)stk_tweetRetweetFont;
+ (UIFont *)stk_tweetAuthorFont;
+ (UIFont *)stk_tweetDetailFont;
+ (UIFont *)stk_tweetBodyFont;
+ (UIFont *)stk_twitterUserNameFont;

+ (UIFont *)stk_settingsItemTitleFont;
+ (UIFont *)stk_settingsHeaderTitleFont;

@end
