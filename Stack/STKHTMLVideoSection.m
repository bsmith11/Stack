//
//  STKHTMLVideoSection.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKHTMLVideoSection.h"

#import "NSString+STKHTML.h"

#import <DTCoreText/DTCoreText.h>

@implementation STKHTMLVideoSection

+ (instancetype)videoSectionWithIframeTextAttachment:(DTIframeTextAttachment *)iframeTextAttachment {
    STKHTMLVideoSection *section = [[STKHTMLVideoSection alloc] init];

    section.sourceURL = iframeTextAttachment.contentURL.absoluteString;
    section.width = @(iframeTextAttachment.originalSize.width);
    section.height = @(iframeTextAttachment.originalSize.height);
    section.linkURL = iframeTextAttachment.hyperLinkURL.absoluteString;

    section.type = [self typeForSourceURL:section.sourceURL];

    return section;
}

+ (instancetype)videoSectionWithObjectTextAttachment:(DTObjectTextAttachment *)objectTextAttachment {
    STKHTMLVideoSection *section = [[STKHTMLVideoSection alloc] init];

    for (DTHTMLElement *element in objectTextAttachment.childNodes) {
        NSString *name = element.attributes[@"name"];
        if ([name isEqualToString:@"width"]) {
            NSString *width = element.attributes[@"value"];
            section.width = @(width.integerValue);
        }
        else if ([name isEqualToString:@"height"]) {
            NSString *height = element.attributes[@"value"];
            section.height = @(height.integerValue);
        }
        else if ([name isEqualToString:@"linkBaseURL"]) {
            NSString *URL = element.attributes[@"value"];
            section.sourceURL = URL;
            section.linkURL = URL;
        }
    }

    section.type = [self typeForSourceURL:section.sourceURL];

    return section;
}

+ (instancetype)videoSectionWithVideoURLString:(NSString *)URLString {
    STKHTMLVideoSection *section = [[STKHTMLVideoSection alloc] init];

    section.sourceURL = URLString;
    section.type = [self typeForSourceURL:section.sourceURL];

    return section;
}

+ (STKHTMLVideoSectionType)typeForSourceURL:(NSString *)sourceURL {
    STKHTMLVideoSectionType type = STKHTMLVideoSectionTypeOther;
//TODO: handle rest of video types
    if ([sourceURL stk_youtubeVideoID]) {
        type = STKHTMLVideoSectionTypeYoutube;
    }
    
    return type;
}

@end
