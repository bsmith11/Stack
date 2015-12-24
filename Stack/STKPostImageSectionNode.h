//
//  STKPostImageSectionNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostSectionNode.h"

@class STKPostImageSection;

@interface STKPostImageSectionNode : STKPostSectionNode

- (void)setupWithSection:(STKPostImageSection *)section;
- (CGRect)imageNodeFrame;

@end
