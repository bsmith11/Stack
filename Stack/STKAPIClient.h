//
//  STKAPIClient.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

#import "STKAPIConstants.h"

@class STKPost, STKAuthor;

@interface STKAPIClient : NSObject

+ (instancetype)sharedInstance;

- (void)getPostsBeforePost:(STKPost *)post
                    author:(STKAuthor *)author
                sourceType:(STKSourceType)sourceType
                completion:(STKAPICompletion)completion;

- (void)searchPostsWithText:(NSString *)text
                 completion:(STKAPICompletion)completion;

- (void)getCommentsForPost:(STKPost *)post
                completion:(STKAPICompletion)completion;

@end
