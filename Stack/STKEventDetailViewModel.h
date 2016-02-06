//
//  STKEventDetailViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import Foundation;

@class STKEventGroup;

@interface STKEventDetailViewModel : NSObject

- (instancetype)initWithEventGroup:(STKEventGroup *)group;

- (void)downloadEventDetailsWithCompletion:(void (^)(NSError *))completion;

@property (strong, nonatomic, readonly) STKEventGroup *group;

@property (assign, nonatomic, readonly) BOOL downloading;

@end
