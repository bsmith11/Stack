//
//  STKPost+Analytical.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPost+Analytical.h"

#import <RZUtils/RZCommonUtils.h>

@implementation STKPost (Analytical)

- (NSDictionary *)analyticsInfo {
    NSDictionary *info = @{@"postID":RZNilToEmptyString(self.postID),
//                           @"sourceName":RZNilToEmptyString(self.source.name),
                           @"postTitle":RZNilToEmptyString(self.title)};

    return info;
}

@end
