//
//  STKAuthor+Analytical.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAuthor+Analytical.h"

#import <RZUtils/RZCommonUtils.h>

@implementation STKAuthor (Analytical)

- (NSDictionary *)analyticsInfo {
    NSDictionary *info = @{@"authorID":RZNilToEmptyString(self.authorID),
//                           @"sourceName":RZNilToEmptyString(self.source.name),
                           @"authorName":RZNilToEmptyString(self.name)};

    return info;
}

@end
