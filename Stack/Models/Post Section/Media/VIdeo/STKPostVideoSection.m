//
//  STKPostVideoSection.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostVideoSection.h"

#import "STKHTMLVideoSection.h"

#import <RZVinyl/RZVinyl.h>

@implementation STKPostVideoSection

+ (instancetype)sectionWithSection:(STKHTMLVideoSection *)section context:(NSManagedObjectContext *)context {
    STKPostVideoSection *postVideoSection = [STKPostVideoSection rzv_newObjectInContext:context];
    [postVideoSection setupWithSection:section];

    return postVideoSection;
}

- (void)setupWithSection:(STKHTMLVideoSection *)section {
    self.sourceURL = section.sourceURL;
    self.linkURL = section.linkURL;
    self.width = section.width;
    self.height = section.height;
    self.type = @(section.type);
    self.index = section.index;
}

@end
