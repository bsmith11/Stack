//
//  STKContentManager.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKContentManager.h"

#import "STKPost.h"
#import "STKAuthor.h"
#import "STKPostSearchResult.h"

@implementation STKContentManager

+ (void)downloadPostsBeforePosts:(NSArray *)posts
                      completion:(STKContentManagerDownloadCompletion)completion {
    NSArray *sourceTypes = [STKSource allSourceTypes];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_group_t group = dispatch_group_create();
        __block NSError *networkError = nil;

        for (NSNumber *sourceType in sourceTypes) {
            NSPredicate *predicate = [STKPost predicateWithSourceType:sourceType.integerValue];
            NSArray *filteredPosts = [posts filteredArrayUsingPredicate:predicate];
            NSArray *sortDescriptors = @[[STKPost createDateSortDescriptor]];
            STKPost *post = [filteredPosts sortedArrayUsingDescriptors:sortDescriptors].lastObject;

            dispatch_group_enter(group);

            [STKPost downloadPostsBeforePost:post
                                      author:nil
                                  sourceType:sourceType.integerValue
                                  completion:^(NSError * _Nullable error) {
                                      NSLog(@"%@ finished downloading...", [STKSource nameForType:sourceType.integerValue]);

                                      if (error) {
                                          networkError = error;
                                          NSLog(@"Error downloading posts: %@", error);
                                      }

                                      dispatch_group_leave(group);
                                  }];
        }

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *fetchedPosts = [STKPost fetchPostsBeforePost:posts.lastObject
                                                               author:nil
                                                           sourceType:-1];
                completion(fetchedPosts, networkError);
            });
        }
    });
}

+ (void)downloadPostsBeforePosts:(NSArray *)posts
                          author:(STKAuthor *)author
                      completion:(STKContentManagerDownloadCompletion)completion {
    [STKPost downloadPostsBeforePost:posts.lastObject
                              author:author
                          sourceType:author.sourceType.integerValue
                          completion:^(NSError * _Nullable error) {
                              NSArray *fetchedPosts = [STKPost fetchPostsBeforePost:posts.lastObject
                                                                             author:author
                                                                         sourceType:-1];
                              if (completion) {
                                  completion(fetchedPosts, error);
                              }
                          }];
}

+ (void)downloadPostsBeforePosts:(NSArray *)posts
                      sourceType:(STKSourceType)sourceType
                      completion:(STKContentManagerDownloadCompletion)completion {
    if (sourceType < 0) {
        [self downloadPostsBeforePosts:posts
                            completion:completion];
    }
    else {
        [STKPost downloadPostsBeforePost:posts.lastObject
                                  author:nil
                              sourceType:sourceType
                              completion:^(NSError * _Nullable error) {
                                  if (error) {
                                      NSLog(@"Error downloading posts: %@", error);
                                  }

                                  NSArray *fetchedPosts = [STKPost fetchPostsBeforePost:posts.lastObject
                                                                                 author:nil
                                                                             sourceType:sourceType];
                                  if (completion) {
                                      completion(fetchedPosts, error);
                                  }
                              }];
    }
}

+ (void)searchPostsWithText:(NSString *)text
                 completion:(STKContentManagerDownloadCompletion)completion {
    NSArray *sourceTypes = [STKSource allSourceTypes];
    NSMutableArray *searchResults = [NSMutableArray array];

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_group_t group = dispatch_group_create();
        __block NSError *networkError = nil;

        for (NSNumber *sourceType in sourceTypes) {
            dispatch_group_enter(group);

            [STKPostSearchResult searchPostsWithText:text
                                          sourceType:sourceType.integerValue
                                          completion:^(NSArray *results, NSError *error) {
                                              NSLog(@"%@ finished searching...", [STKSource nameForType:sourceType.integerValue]);

                                              if (error) {
                                                  networkError = error;
                                                  NSLog(@"Error searching posts: %@", error);
                                              }
                                              else {
                                                  [searchResults addObjectsFromArray:results];
                                              }

                                              dispatch_group_leave(group);
            }];
        }

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(searchResults, networkError);
            });
        }
    });
}

+ (void)searchPostsWithText:(NSString *)text
                 sourceType:(STKSourceType)sourceType
                 completion:(STKContentManagerDownloadCompletion)completion {
    if (sourceType < 0) {
        [self searchPostsWithText:text
                       completion:completion];
    }
    else {
        [STKPostSearchResult searchPostsWithText:text
                                      sourceType:sourceType
                                      completion:completion];
    }
}

+ (void)cancelPreviousPostSearches {
    [STKPostSearchResult cancelPreviousPostSearches];
}

@end
