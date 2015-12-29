//
//  UIFont+STKStyle.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIFont+STKStyle.h"

CGFloat const kSTKDefaultFontSize = 16.0f;
CGFloat const kSTKDefaultFontLineSpacing = 2.5f;

static NSString * const kSTKDefaultFontName = @"Gotham-Book";
static NSString * const kSTKDefaultFontNameItalics = @"Gotham-BookItalic";
static NSString * const kSTKDefaultFontNameBold = @"Gotham-Bold";

@implementation UIFont (STKStyle)

#pragma mark - Navigation Bar

+ (UIFont *)stk_navigationBarTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:20.0f];
}

#pragma mark - Error

+ (UIFont *)stk_errorTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:18.0f];
}

+ (UIFont *)stk_errorMessageFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

#pragma mark - Onboarding

+ (UIFont *)stk_onboardingTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:24.0f];
}

+ (UIFont *)stk_onboardingMessageFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:18.0f];
}

+ (UIFont *)stk_onboardingActionFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:18.0f];
}

#pragma mark - Post Node

+ (UIFont *)stk_postNodeTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:16.0f];
}

+ (UIFont *)stk_postNodeDateFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:12.0f];
}

#pragma mark - Post

+ (UIFont *)stk_postAuthorFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:18.0f];
}

+ (UIFont *)stk_postDateFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

+ (UIFont *)stk_postTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:20.0f];
}

+ (UIFont *)stk_postBodyFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:16.0f];
}

+ (UIFont *)stk_postCommentTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:24.0f];
}

#pragma mark - Comment Node

+ (UIFont *)stk_commentNodeAuthorFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:14.0f];
}

+ (UIFont *)stk_commentNodeDateFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

+ (UIFont *)stk_commentNodeBodyFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

#pragma mark - Author

+ (UIFont *)stk_authorNameFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:24.0f];
}

+ (UIFont *)stk_authorSummaryFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

#pragma mark - Source

+ (UIFont *)stk_sourceNameFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:24.0f];
}

+ (UIFont *)stk_sourceSummaryFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

#pragma mark - Empty State

+ (UIFont *)stk_emptyStateTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontNameBold size:20.0f];
}

+ (UIFont *)stk_emptyStateMessageFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:16.0f];
}

+ (UIFont *)stk_emptyStateActionFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:16.0f];
}

#pragma mark - Filter

+ (UIFont *)stk_filterSourceFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:18.0f];
}

#pragma mark - Search Text Field

+ (UIFont *)stk_searchTextFieldFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

#pragma mark - Twitter

+ (UIFont *)stk_tweetRetweetFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:12.0f];
}

+ (UIFont *)stk_tweetAuthorFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

+ (UIFont *)stk_tweetDetailFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:12.0f];
}

+ (UIFont *)stk_tweetBodyFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:12.0f];
}

+ (UIFont *)stk_twitterUserNameFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:18.0f];
}

#pragma mark - Settings

+ (UIFont *)stk_settingsItemTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:18.0f];
}

+ (UIFont *)stk_settingsHeaderTitleFont {
    return [UIFont fontWithName:kSTKDefaultFontName size:14.0f];
}

@end
