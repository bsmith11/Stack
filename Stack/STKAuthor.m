//
//  STKAuthor.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAuthor.h"
#import "STKPost.h"

@implementation STKAuthor

- (NSAttributedString *)attributedSummary {
    NSAttributedString *attributedSummary = nil;

    if (self.summary) {
        attributedSummary = [NSKeyedUnarchiver unarchiveObjectWithData:self.summary];
    }

    return attributedSummary;
}

@end
