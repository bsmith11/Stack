//
//  STKFormatter.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKFormatter.h"

static NSString * const kSTKWordpressAPIDateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
static NSString * const kSTKTwitterAPIDateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
static NSString * const kSTKBloggerAPIDateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";
static NSString * const kSTKEventAPIDateFormat = @"M/d/y h:mm:ss a";
static NSString * const kSTKEventGameDateAPIDateFormat = @"M/d/y";
static NSString * const kSTKEventGameTimeAPIDateFormat = @"h:mm a";
static NSString * const kSTKEventGameDisplayDateFormat = @"E h:mm a";

@implementation STKFormatter

+ (NSDateFormatter *)wordpressDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kSTKWordpressAPIDateFormat];
    });

    return dateFormatter;
}

+ (NSDateFormatter *)twitterDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kSTKTwitterAPIDateFormat];
    });

    return dateFormatter;
}

+ (NSDateFormatter *)bloggerDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:kSTKBloggerAPIDateFormat];
    });

    return dateFormatter;
}

+ (NSDateFormatter *)eventDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [dateFormatter setDateFormat:kSTKEventAPIDateFormat];
    });

    return dateFormatter;
}

+ (NSDateFormatter *)gameDateDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [dateFormatter setDateFormat:kSTKEventGameDateAPIDateFormat];
    });

    return dateFormatter;
}

+ (NSDateFormatter *)gameTimeDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [dateFormatter setDateFormat:kSTKEventGameTimeAPIDateFormat];
    });

    return dateFormatter;
}

+ (NSDateFormatter *)gameDisplayDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [dateFormatter setDateFormat:kSTKEventGameDisplayDateFormat];
    });

    return dateFormatter;
}

@end
