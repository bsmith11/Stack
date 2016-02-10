//
//  STKContentManager.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;

@class STKAuthor;

typedef void (^ _Nullable STKContentManagerDownloadCompletion)(NSArray * _Nullable posts, NSError * _Nullable error);

@interface STKContentManager : NSObject

+ (void)downloadPostsBeforePosts:(NSArray * _Nullable)posts
                      completion:(STKContentManagerDownloadCompletion)completion;

+ (void)downloadPostsBeforePosts:(NSArray * _Nullable)posts
                          author:(STKAuthor * _Nonnull)author
                      completion:(STKContentManagerDownloadCompletion)completion;

+ (void)downloadPostsBeforePosts:(NSArray * _Nullable)posts
                      sourceType:(STKSourceType)sourceType
                      completion:(STKContentManagerDownloadCompletion)completion;

+ (void)searchPostsWithText:(NSString * _Nullable)text
                 sourceType:(STKSourceType)sourceType
                 completion:(STKContentManagerDownloadCompletion)completion;

+ (void)cancelPreviousPostSearches;

@end
