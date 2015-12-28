//
//  STKRSSSessionManager.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKRSSSessionManager.h"

#import "STKRSSPost.h"

#import "STKAnalyticsManager.h"
#import "RSSItem+STKImport.h"

#import <BlockRSSParser/RSSParser.h>

@interface STKRSSSessionManager ()

@property (strong, nonatomic, readwrite) NSURL *baseURL;

@property (assign, nonatomic, readwrite) STKSourceType sourceType;
@property (assign, nonatomic) NSInteger page;

@end

@implementation STKRSSSessionManager

- (instancetype)initWithSourceType:(STKSourceType)sourceType {
    self = [super init];

    if (self) {
        self.baseURL = [STKSource baseURLForType:sourceType];
        self.sourceType = sourceType;
        self.page = 0;
    }

    return self;
}

- (void)getPostsBeforePost:(STKPost *)post
                    author:(STKAuthor *)author
                completion:(STKAPICompletion)completion {
    if (!post) {
        self.page = 0;
    }

    NSString *pageString = [NSString stringWithFormat:@"?paged=%@", @(self.page)];
    NSString *URLString = [self.baseURL.absoluteString stringByAppendingString:pageString];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];

    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        self.page++;

        NSArray *responseObject = [RSSItem stk_postImportDictionariesFromArray:feedItems];

        if (completion) {
            completion(responseObject, nil, self.sourceType);
        }
    } failure:^(NSError *error) {
        [STKAnalyticsManager logEventDidFailRequest:request error:error];

        if (completion) {
            completion(nil, error, self.sourceType);
        }
    }];
}

- (void)getCommentsForPost:(STKPost *)post completion:(STKAPICompletion)completion {
    STKRSSPost *RSSPost = (STKRSSPost *)post;

    if (RSSPost.commentsRSS.length > 0) {
        NSURL *URL = [NSURL URLWithString:RSSPost.commentsRSS];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];

        [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
            NSArray *responseObject = [RSSItem stk_commentImportDictionariesFromArray:feedItems postID:post.postID];

            if (completion) {
                completion(responseObject, nil, self.sourceType);
            }
        } failure:^(NSError *error) {
            if (error.code != NSURLErrorCancelled) {
                [STKAnalyticsManager logEventDidFailRequest:request error:error];
            }

            if (completion) {
                completion(nil, error, self.sourceType);
            }
        }];
    }
    else {
        if (completion) {
            completion([NSArray array], nil, self.sourceType);
        }
    }
}

- (void)searchPostsWithText:(NSString *)text completion:(STKAPICompletion)completion {
    if (completion) {
        completion(nil, nil, self.sourceType);
    }
}

- (void)cancelPreviousPostSearches {

}

@end
