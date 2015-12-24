//
//  STKAttachment.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAttachment.h"
#import "STKHTMLImageSection.h"

#import <RZVinyl/RZVinyl.h>

@implementation STKAttachment

#pragma mark - Lifecycle

+ (instancetype)attachmentWithSection:(STKHTMLImageSection *)section context:(NSManagedObjectContext *)context {
    STKAttachment *attachment = [STKAttachment rzv_newObjectInContext:context];
    [attachment setupWithSection:section];

    return attachment;
}

#pragma mark - Setup

- (void)setupWithSection:(STKHTMLImageSection *)section {
    self.width = section.width;
    self.height = section.height;
    self.sourceURL = section.sourceURL;
}

@end
