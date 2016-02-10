//
//  STKSettingsHeader.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSettingsHeader.h"

@implementation STKSettingsHeader

#pragma mark - Lifecycle

+ (instancetype)headerWithTitle:(NSAttributedString *)title {
    STKSettingsHeader *header = [[STKSettingsHeader alloc] init];
    header.title = title;

    return header;
}

@end
