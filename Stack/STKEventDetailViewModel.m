//
//  STKEventDetailViewModel.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventDetailViewModel.h"

#import "STKEvent.h"
#import "STKEventGroup.h"
#import "STKEventRound.h"

#import "NSArray+STKEquality.h"

@interface STKEventDetailViewModel ()

@property (strong, nonatomic, readwrite) STKEventGroup *group;
@property (strong, nonatomic, readwrite) NSArray *segmentTypes;

@property (assign, nonatomic, readwrite) BOOL downloading;

@end

@implementation STKEventDetailViewModel

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.group = group;
        self.segmentTypes = [NSArray array];

        [self updateSegmentTypes];

        __weak __typeof(self) wself = self;
        [self downloadEventDetailsWithCompletion:nil];
    }

    return self;
}

#pragma mark - Actions

- (NSString *)titleForSegmentType:(STKEventDetailSegmentType)type {
    NSString *title = @"TBD";

    switch (type) {
        case STKEventDetailSegmentTypePools:
            title = @"Pools";
            break;

        case STKEventDetailSegmentTypeCrossovers:
            title = @"Crossovers";
            break;

        case STKEventDetailSegmentTypeBrackets:
            title = @"Brackets";
            break;
    }

    return title;
}

- (void)updateSegmentTypes {
    NSMutableOrderedSet *segmentTypesSet = [NSMutableOrderedSet orderedSet];

    for (STKEventRound *round in self.group.rounds) {
        if (round.pools.count > 0) {
            [segmentTypesSet addObject:@(STKEventDetailSegmentTypePools)];
        }

        if (round.clusters.count > 0) {
            [segmentTypesSet addObject:@(STKEventDetailSegmentTypeCrossovers)];
        }

        if (round.brackets.count > 0) {
            [segmentTypesSet addObject:@(STKEventDetailSegmentTypeBrackets)];
        }
    }

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *segmentTypes = [segmentTypesSet sortedArrayUsingDescriptors:@[sortDescriptor]];

    if (![self.segmentTypes stk_contentsIsEqualToArray:segmentTypes]) {
        self.segmentTypes = segmentTypes;
    }
}

- (void)downloadEventDetailsWithCompletion:(void (^)(NSError *))completion {
    self.downloading = YES;

    __weak __typeof(self) wself = self;
    [STKEvent downloadDetailsForEvent:self.group.event completion:^(NSError * _Nonnull error) {
        [wself updateSegmentTypes];

        wself.downloading = NO;

        if (completion) {
            completion(error);
        }
    }];
}

@end
