//
//  STKHTMLVideoSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKHTMLMediaSection.h"

typedef NS_ENUM(NSInteger, STKHTMLVideoSectionType) {
    STKHTMLVideoSectionTypeYoutube,
    STKHTMLVideoSectionTypeVimeo,
    STKHTMLVideoSectionTypeSoundcloud,
    STKHTMLVideoSectionTypeOther
};

@class DTIframeTextAttachment, DTObjectTextAttachment;

@interface STKHTMLVideoSection : STKHTMLMediaSection

+ (instancetype)videoSectionWithIframeTextAttachment:(DTIframeTextAttachment *)iframeTextAttachment;
+ (instancetype)videoSectionWithObjectTextAttachment:(DTObjectTextAttachment *)objectTextAttachment;
+ (instancetype)videoSectionWithVideoURLString:(NSString *)URLString;

@property (assign, nonatomic) STKHTMLVideoSectionType type;

@end
