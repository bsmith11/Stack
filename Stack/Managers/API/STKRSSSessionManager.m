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
#import "STKAPIRSSConstants.h"

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

    __weak __typeof(self) wself = self;
    [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
        wself.page++;

        NSMutableArray *responseObject = [RSSItem stk_postImportDictionariesFromArray:feedItems];
        [wself prefixValuesForPosts:responseObject];

        if (completion) {
            completion(responseObject, nil, wself.sourceType);
        }
    } failure:^(NSError *error) {
        [STKAnalyticsManager logEventDidFailRequest:request error:error];

        if (completion) {
            completion(nil, error, wself.sourceType);
        }
    }];
}

- (void)getCommentsForPost:(STKPost *)post completion:(STKAPICompletion)completion {
    STKRSSPost *RSSPost = (STKRSSPost *)post;

    if (RSSPost.commentsRSS.length > 0) {
        NSURL *URL = [NSURL URLWithString:RSSPost.commentsRSS];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];

        __weak __typeof(self) wself = self;
        [RSSParser parseRSSFeedForRequest:request success:^(NSArray *feedItems) {
            NSMutableArray *responseObject = [RSSItem stk_commentImportDictionariesFromArray:feedItems];
            [wself prefixValuesForComments:responseObject];

            if (completion) {
                completion(responseObject, nil, wself.sourceType);
            }
        } failure:^(NSError *error) {
            if (error.code != NSURLErrorCancelled) {
                [STKAnalyticsManager logEventDidFailRequest:request error:error];
            }

            if (completion) {
                completion(nil, error, wself.sourceType);
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

- (void)prefixValuesForPosts:(NSMutableArray *)responseObject {
    NSArray *keyPaths = @[kSTKAPIRSSResponseKeyID, kSTKAPIRSSResponseKeyAuthor];

    for (NSMutableDictionary *dictionary in responseObject) {
        [self prefixValuesForKeyPaths:keyPaths inDictionary:dictionary];
    }
}

- (void)prefixValuesForComments:(NSMutableArray *)responseObject {
    NSArray *keyPaths = @[kSTKAPIRSSResponseKeyID];

    for (NSMutableDictionary *dictionary in responseObject) {
        [self prefixValuesForKeyPaths:keyPaths inDictionary:dictionary];
    }
}

- (void)prefixValuesForKeyPaths:(NSArray *)keyPaths inDictionary:(NSMutableDictionary *)dictionary {
    for (NSString *keyPath in keyPaths) {
        id oldValue = [dictionary valueForKeyPath:keyPath];
        if (![oldValue isKindOfClass:[NSNull class]]) {
            NSString *newValue = [NSString stringWithFormat:@"%@_%@", @(self.sourceType).stringValue, oldValue];

            [dictionary setValue:newValue forKeyPath:keyPath];
        }
    }
}

@end
