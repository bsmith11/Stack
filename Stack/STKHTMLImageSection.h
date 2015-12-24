//
//  STKHTMLImageSection.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKHTMLMediaSection.h"

@class DTImageTextAttachment;

@interface STKHTMLImageSection : STKHTMLMediaSection

+ (instancetype)imageSectionWithImageTextAttachment:(DTImageTextAttachment *)imageTextAttachment;

@end
