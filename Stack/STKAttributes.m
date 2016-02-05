//
//  STKAttributes.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAttributes.h"

#import "UIColor+STKStyle.h"
#import "UIFont+STKStyle.h"

@implementation STKAttributes

#pragma mark - Navigation Bar

+ (NSDictionary *)stk_navigationBarTitleAttributes {
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:[UIFont stk_navigationBarTitleFont]};

    return attributes;
}

#pragma mark - Error

+ (NSDictionary *)stk_errorTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_errorTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_errorMessageAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_errorMessageFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Onboarding

+ (NSDictionary *)stk_welcomeTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_welcomeTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_onboardingTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_onboardingTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_onboardingMessageAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_onboardingMessageFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_onboardingActionAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_twitterColor],
                                 NSFontAttributeName:[UIFont stk_onboardingActionFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Post Node

+ (NSDictionary *)stk_postNodeTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_postNodeTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_postNodeDateAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSFontAttributeName:[UIFont stk_postNodeDateFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Post

+ (NSDictionary *)stk_postAuthorAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_postAuthorFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_postDateAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSFontAttributeName:[UIFont stk_postDateFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_postTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8.0f;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_postTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_postBodyAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_postBodyFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_postCommentTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_postCommentTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Comment Node

+ (NSDictionary *)stk_commentNodeAuthorAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_commentNodeAuthorFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_commentNodeDateAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSFontAttributeName:[UIFont stk_commentNodeDateFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_commentNodeBodyAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_commentNodeBodyFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Author

+ (NSDictionary *)stk_authorNameAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_authorNameFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_authorSummaryAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_authorSummaryFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Source

+ (NSDictionary *)stk_sourceNameAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_sourceNameFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_sourceSummaryAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_sourceSummaryFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Unavailable Message

+ (NSDictionary *)stk_unavailableTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_emptyStateTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_unavailableMessageAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_emptyStateMessageFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_unavailableActionAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_twitterColor],
                                 NSFontAttributeName:[UIFont stk_emptyStateActionFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Empty State

+ (NSDictionary *)stk_emptyStateTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_emptyStateTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_emptyStateMessageAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_emptyStateMessageFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_emptyStateActionAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_twitterColor],
                                 NSFontAttributeName:[UIFont stk_emptyStateActionFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Filter

+ (NSDictionary *)stk_filterSourceAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_filterSourceFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Search Text Field

+ (NSDictionary *)stk_searchTextFieldPlaceholderAttributes {
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_searchTextFieldFont]};

    return attributes;
}

#pragma mark - Twitter

+ (NSDictionary *)stk_tweetRetweetAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSFontAttributeName:[UIFont stk_tweetRetweetFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_tweetAuthorAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_tweetAuthorFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_tweetDetailAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSFontAttributeName:[UIFont stk_tweetDetailFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_tweetBodyAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_tweetBodyFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

+ (NSDictionary *)stk_twitterUserNameAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kSTKDefaultFontLineSpacing;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_twitterUserNameFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

#pragma mark - Settings

+ (NSDictionary *)stk_settingsItemTitleAttributes {
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_settingsItemTitleFont]};

    return attributes;
}

+ (NSDictionary *)stk_settingsHeaderTitleAttributes {
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor stk_stackColor],
                                 NSFontAttributeName:[UIFont stk_settingsHeaderTitleFont]};
    
    return attributes;
}

#pragma mark - Events

+ (NSDictionary *)stk_eventsFilterTitleAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:[UIFont stk_eventsFilterTitleFont],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    return attributes;
}

@end
