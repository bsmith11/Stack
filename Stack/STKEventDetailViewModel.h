//
//  STKEventDetailViewModel.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, STKEventDetailSegmentType) {
    STKEventDetailSegmentTypePools,
    STKEventDetailSegmentTypeCrossovers,
    STKEventDetailSegmentTypeBrackets
};

@class STKEventGroup;

@interface STKEventDetailViewModel : NSObject

- (instancetype)initWithEventGroup:(STKEventGroup *)group;

- (NSString *)titleForSegmentType:(STKEventDetailSegmentType)type;

- (void)downloadEventDetailsWithCompletion:(void (^)(NSError *))completion;

@property (strong, nonatomic, readonly) STKEventGroup *group;
@property (strong, nonatomic, readonly) NSArray *segmentTypes;

@property (assign, nonatomic, readonly) BOOL downloading;

@end
