//
//  STKAuthor.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAuthor.h"
#import "STKPost.h"

#import <RZVinyl/RZVinyl.h>
#import <RZDataBinding/RZDataBinding.h>

@implementation STKAuthor

#pragma mark - RZVinyl

+ (NSPredicate *)rzv_stalenessPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"posts.@count == %@", @0];

    return predicate;
}

- (NSAttributedString *)attributedSummary {
    NSAttributedString *attributedSummary = nil;

    if (self.summary) {
        attributedSummary = [NSKeyedUnarchiver unarchiveObjectWithData:self.summary];
    }

    return attributedSummary;
}

@end
