//
//  STKSessionManagerProtocol.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import "STKAPIConstants.h"

@class STKPost, STKAuthor;

@protocol STKSessionManagerProtocol <NSObject>

- (instancetype)initWithSourceType:(STKSourceType)sourcetype;

- (void)getPostsBeforePost:(STKPost *)post
                    author:(STKAuthor *)author
                completion:(STKAPICompletion)completion;

- (void)searchPostsWithText:(NSString *)text completion:(STKAPICompletion)completion;
- (void)cancelPreviousPostSearches;
- (void)getCommentsForPost:(STKPost *)post completion:(STKAPICompletion)completion;

@property (assign, nonatomic, readonly) STKSourceType sourceType;

@end
