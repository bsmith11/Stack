//
//  STKHTMLImageSection.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKHTMLImageSection.h"

#import <DTCoreText/DTCoreText.h>

@implementation STKHTMLImageSection

+ (instancetype)imageSectionWithImageTextAttachment:(DTImageTextAttachment *)imageTextAttachment {
    STKHTMLImageSection *section = [[STKHTMLImageSection alloc] init];

    section.sourceURL = imageTextAttachment.contentURL.absoluteString;
    section.width = @(imageTextAttachment.originalSize.width);
    section.height = @(imageTextAttachment.originalSize.height);
    section.linkURL = imageTextAttachment.hyperLinkURL.absoluteString;

    return section;
}

@end
