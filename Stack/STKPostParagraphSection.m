//
//  STKPostParagraphSection.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostParagraphSection.h"

#import "STKHTMLParagraphSection.h"

#import <RZVinyl/RZVinyl.h>

@implementation STKPostParagraphSection

+ (instancetype)sectionWithSection:(STKHTMLParagraphSection *)section context:(NSManagedObjectContext *)context {
    STKPostParagraphSection *postTextSection = [STKPostParagraphSection rzv_newObjectInContext:context];
    [postTextSection setupWithSection:section];

    return postTextSection;
}

- (void)setupWithSection:(STKHTMLParagraphSection *)section {
    self.content = [NSKeyedArchiver archivedDataWithRootObject:section.content];
    self.index = section.index;
}

- (NSAttributedString *)attributedContent {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.content];
}

@end
