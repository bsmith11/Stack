//
//  STKWordpressSessionManager.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKWordpressSessionManager.h"

#import "STKPost.h"
#import "STKAuthor.h"

#import "STKFormatter.h"
#import "STKAPIWordpressConstants.h"

#import <RZUtils/RZCommonUtils.h>

static NSInteger const kSTKWordpressSessionManagerPostsPerPage = 20;

@interface STKWordpressSessionManager ()

@property (strong, nonatomic) NSURLSessionDataTask *searchTask;

@property (assign, nonatomic, readwrite) STKSourceType sourceType;

@end

@implementation STKWordpressSessionManager

- (instancetype)initWithSourceType:(STKSourceType)sourceType {
    NSURL *baseURL = [STKSource baseURLForType:sourceType];
    self = [super initWithBaseURL:baseURL];

    if (self) {
        self.sourceType = sourceType;
    }

    return self;
}

- (NSString *)pathWithRoute:(NSString *)route {
    NSString *path = [NSString stringWithFormat:@"%@%@", kSTKAPIWordpressRoutePrefix, route];

    return path;
}

- (void)getPostsBeforePost:(STKPost *)post
                    author:(STKAuthor *)author
                completion:(STKAPICompletion)completion {
    NSDate *date = post.createDate ?: [NSDate date];
    NSString *dateString = [[STKFormatter wordpressDateFormatter] stringFromDate:date];
    NSMutableDictionary *filterDictionary = [NSMutableDictionary dictionary];

    if (author) {
        NSString *authorID = [author.authorID componentsSeparatedByString:@"_"].lastObject;
        filterDictionary[kSTKAPIWordpressRequestKeyAuthor] = RZNilToNSNull(authorID);
    }

    filterDictionary[kSTKAPIWordpressRequestKeyDateQuery] = @{kSTKAPIWordpressRequestKeyBefore:RZNilToNSNull(dateString)};
    filterDictionary[kSTKAPIWordpressRequestKeyPostsPerPage] = @(kSTKWordpressSessionManagerPostsPerPage);

    NSDictionary *parameters = @{kSTKAPIWordpressRequestKeyFilter:filterDictionary};
    NSString *path = [self pathWithRoute:kSTKAPIWordpressRoutePosts];

    __weak __typeof(self) wself = self;
    [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
        [wself prefixValuesForPosts:responseObject];

        if (completion) {
            completion(responseObject, error, wself.sourceType);
        }
    }];
}

- (void)searchPostsWithText:(NSString *)text completion:(STKAPICompletion)completion {
    [self.searchTask cancel];

    if (text.length > 0) {
        NSDictionary *parameters = @{kSTKAPIWordpressRequestKeyFilter:@{kSTKAPIWordpressRequestKeySearch:text,
                                                                       kSTKAPIWordpressRequestKeyPostsPerPage:@(kSTKWordpressSessionManagerPostsPerPage)}};

        NSString *path = [self pathWithRoute:kSTKAPIWordpressRoutePosts];

        __weak __typeof(self) wself = self;
        NSURLSessionDataTask *searchTask = [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
            [wself prefixValuesForPosts:responseObject];

            if (completion) {
                completion(responseObject, error, wself.sourceType);
            }
        }];

        self.searchTask = searchTask;
    }
}

- (void)cancelPreviousPostSearches {
    [self.searchTask cancel];
}

- (void)getCommentsForPost:(STKPost *)post completion:(STKAPICompletion)completion {
    NSString *postID = [post.postID componentsSeparatedByString:@"_"].lastObject;
    NSString *path = [self pathWithRoute:[NSString stringWithFormat:kSTKAPIWordpressRoutePostComments, postID]];

    __weak __typeof(self) wself = self;
    [self GET:path parameters:nil completion:^(id responseObject, NSError *error) {
        [wself prefixValuesForComments:responseObject];

        if (completion) {
            completion(responseObject, error, wself.sourceType);
        }
    }];
}

- (void)prefixValuesForPosts:(NSMutableArray *)responseObject {
    NSArray *keyPaths = @[kSTKAPIWordpressResponseKeyID, [NSString stringWithFormat:@"%@.%@", kSTKAPIWordpressResponseKeyAuthor, kSTKAPIWordpressResponseKeyID], [NSString stringWithFormat:@"%@.%@", kSTKAPIWordpressResponseKeyFeaturedImage, kSTKAPIWordpressResponseKeyID]];

    for (NSMutableDictionary *dictionary in responseObject) {
        [self prefixValuesForKeyPaths:keyPaths inDictionary:dictionary];
    }
}

- (void)prefixValuesForComments:(NSMutableArray *)responseObject {
    NSArray *keyPaths = @[kSTKAPIWordpressResponseKeyID];

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
