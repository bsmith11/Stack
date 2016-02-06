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

@interface STKEventDetailViewModel ()

@property (strong, nonatomic, readwrite) STKEventGroup *group;

@property (assign, nonatomic, readwrite) BOOL downloading;

@end

@implementation STKEventDetailViewModel

#pragma mark - Lifecycle

- (instancetype)initWithEventGroup:(STKEventGroup *)group {
    self = [super init];

    if (self) {
        self.group = group;

        [self downloadEventDetailsWithCompletion:nil];
    }

    return self;
}

#pragma mark - Actions

- (void)downloadEventDetailsWithCompletion:(void (^)(NSError *))completion {
    self.downloading = YES;

    __weak __typeof(self) wself = self;
    [STKEvent downloadDetailsForEvent:self.group.event completion:^(NSError * _Nonnull error) {
        wself.downloading = NO;

        if (completion) {
            completion(error);
        }
    }];
}

@end
