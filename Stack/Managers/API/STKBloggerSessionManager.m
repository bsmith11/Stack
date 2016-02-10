//
//  STKBloggerSessionManager.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBloggerSessionManager.h"

#import "STKFormatter.h"

#import "STKPost.h"
#import "STKAuthor.h"

#import "STKAPIBloggerConstants.h"

#import <RZUtils/RZCommonUtils.h>
#import <Keys/StackKeys.h>

static NSInteger const kSTKBloggerSessionManagerPostsPerPage = 20;

@interface STKBloggerSessionManager ()

@property (strong, nonatomic, readwrite) NSString *blogID;
@property (strong, nonatomic) NSURLSessionDataTask *searchTask;

@property (assign, nonatomic, readwrite) STKSourceType sourceType;

@end

@implementation STKBloggerSessionManager

- (instancetype)initWithBlogID:(NSString *)blogID sourceType:(STKSourceType)sourceType {
    self = [self initWithSourceType:sourceType];

    if (self) {
        self.blogID = blogID;
    }

    return self;
}

- (instancetype)initWithSourceType:(STKSourceType)sourceType {
    self = [super initWithBaseURL:[STKSource baseURLForType:sourceType]];

    if (self) {
        self.sourceType = sourceType;
    }

    return self;
}

- (NSString *)pathWithRoute:(NSString *)route {
    NSString *path = [NSString stringWithFormat:@"%@/%@%@", kSTKAPIBloggerRoutePrefix, self.blogID, route];

    return path;
}

- (void)getPostsBeforePost:(STKPost *)post
                    author:(STKAuthor *)author
                completion:(STKAPICompletion)completion {
    NSDate *date = post.createDate ?: [NSDate date];
    NSString *dateString = [[STKFormatter bloggerDateFormatter] stringFromDate:date];
    NSNumber *blogID = self.blogID ? @(self.blogID.longLongValue) : @(0);
    StackKeys *keys = [[StackKeys alloc] init];
    NSString *bloggerAPIKey = keys.bloggerAPIKey ?: @"";

    NSDictionary *parameters = @{kSTKAPIBloggerRequestKeyBlogID:blogID,
                                 kSTKAPIBloggerRequestKeyEndDate:dateString,
                                 kSTKAPIBloggerRequestKeyMaxResults:@(kSTKBloggerSessionManagerPostsPerPage),
                                 kSTKAPIBloggerRequestKeyStatus:kSTKAPIBloggerRequestValueStatus,
                                 kSTKAPIBloggerRequestKeyFetchImages:@"true",
                                 kSTKAPIBloggerRequestKeyAPIKey:bloggerAPIKey};
    NSString *path = [self pathWithRoute:kSTKAPIBloggerRoutePosts];

    __weak __typeof(self) wself = self;
    [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
        NSMutableArray *posts = responseObject[kSTKAPIBloggerResponseKeyItems];
        [wself prefixValuesForPosts:posts];

        if (completion) {
            completion(posts, error, wself.sourceType);
        }
    }];
}

- (void)searchPostsWithText:(NSString *)text completion:(STKAPICompletion)completion {
    [self.searchTask cancel];

    if (text.length > 0) {
        NSNumber *blogID = self.blogID ? @(self.blogID.longLongValue) : @(0);
        StackKeys *keys = [[StackKeys alloc] init];
        NSString *bloggerAPIKey = keys.bloggerAPIKey ?: @"";

        NSDictionary *parameters = @{kSTKAPIBloggerRequestKeyBlogID:blogID,
                                     kSTKAPIBloggerRequestKeyQuery:text,
                                     kSTKAPIBloggerRequestKeyAPIKey:bloggerAPIKey};
        NSString *path = [self pathWithRoute:kSTKAPIBloggerRoutePostsSearch];

        __weak __typeof(self) wself = self;
        NSURLSessionDataTask *searchTask = [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
            NSMutableArray *posts = responseObject[kSTKAPIBloggerResponseKeyItems];
            [wself prefixValuesForPosts:posts];

            if (completion) {
                completion(posts, error, wself.sourceType);
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
    NSNumber *blogID = self.blogID ? @(self.blogID.longLongValue) : @(0);
    StackKeys *keys = [[StackKeys alloc] init];
    NSString *bloggerAPIKey = keys.bloggerAPIKey ?: @"";

    NSDictionary *parameters = @{kSTKAPIBloggerRequestKeyBlogID:blogID,
                                 kSTKAPIBloggerRequestKeyPostID:postID,
                                 kSTKAPIBloggerRequestKeyStatus:kSTKAPIBloggerRequestValueStatus,
                                 kSTKAPIBloggerRequestKeyFetchBodies:@"true",
                                 kSTKAPIBloggerRequestKeyAPIKey:bloggerAPIKey};
    NSString *path = [self pathWithRoute:[NSString stringWithFormat:kSTKAPIBloggerRoutePostComments, postID]];

    __weak __typeof(self) wself = self;
    [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
        NSMutableArray *comments = responseObject[kSTKAPIBloggerResponseKeyItems];
        [wself prefixValuesForComments:comments];
        
        if (completion) {
            completion(comments, error, wself.sourceType);
        }
    }];
}

- (void)prefixValuesForPosts:(NSMutableArray *)responseObject {
    NSArray *keyPaths = @[kSTKAPIBloggerResponseKeyID, [NSString stringWithFormat:@"%@.%@", kSTKAPIBloggerResponseKeyAuthor, kSTKAPIBloggerResponseKeyID]];

    for (NSMutableDictionary *dictionary in responseObject) {
        [self prefixValuesForKeyPaths:keyPaths inDictionary:dictionary];
    }
}

- (void)prefixValuesForComments:(NSMutableArray *)responseObject {
    NSArray *keyPaths = @[kSTKAPIBloggerResponseKeyID];

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
