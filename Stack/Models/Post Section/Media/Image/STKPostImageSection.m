//
//  STKPostImageSection.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostImageSection.h"

#import "STKHTMLImageSection.h"

#import <RZVinyl/RZVinyl.h>

@implementation STKPostImageSection

+ (instancetype)sectionWithSection:(STKHTMLImageSection *)section context:(NSManagedObjectContext *)context {
    STKPostImageSection *postImageSection = [STKPostImageSection rzv_newObjectInContext:context];
    [postImageSection setupWithSection:section];

    return postImageSection;
}

- (void)setupWithSection:(STKHTMLImageSection *)section {
    self.sourceURL = section.sourceURL;
    self.linkURL = section.linkURL;
    self.width = section.width;
    self.height = section.height;
    self.index = section.index;
}

@end
