//
//  STKPostParagraphSectionNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostSectionNode.h"

@class STKPostParagraphSection;

@interface STKPostParagraphSectionNode : STKPostSectionNode

- (void)setupWithSection:(STKPostParagraphSection *)section;

@end
