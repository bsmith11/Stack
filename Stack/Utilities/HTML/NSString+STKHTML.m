//
//  NSString+STKHTML.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "NSString+STKHTML.h"

@implementation NSString (STKHTML)

- (BOOL)stk_isVideoURL {
    return [self stk_isYoutubeURL] || [self stk_isVimeoURL] || [self stk_isGfycatURL] || [self stk_isSoundCloudURL];
}

- (NSString *)stk_youtubeVideoID {
    NSString *pattern = @"(?<=watch\\?v=|/videos/|embed\\/)[^#\\&\\?]*";
    NSString *youtubeVideoID = [self stk_stringMatchingRegexPattern:pattern];

    if (!youtubeVideoID) {
        NSString *pattern2 = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
        youtubeVideoID = [self stk_stringMatchingRegexPattern:pattern2];
    }

    return youtubeVideoID;
}

- (BOOL)stk_isYoutubeURL {
    return ([self stk_youtubeVideoID].length > 0);
}

- (BOOL)stk_isVimeoURL {
    return [self containsString:@"vimeo.com/"];
}

- (BOOL)stk_isGfycatURL {
    return [self containsString:@"gfycat.com/"];
}

- (BOOL)stk_isSoundCloudURL {
    return [self containsString:@"soundcloud.com/"];
}

- (NSString *)stk_stringMatchingRegexPattern:(NSString *)pattern {
    NSMutableArray *strings = [NSMutableArray array];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (!error) {
        [regex enumerateMatchesInString:self
                                options:0
                                  range:NSMakeRange(0, [self length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 [strings addObject:[self substringWithRange:[result range]]];
                             }];
    }

    return strings.firstObject;
}

@end
