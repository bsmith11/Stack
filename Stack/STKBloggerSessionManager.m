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
                                 kSTKAPIBloggerRequestKeyStatus:KSTKAPIBloggerRequestValueStatus,
                                 kSTKAPIBloggerRequestKeyFetchImages:@"true",
                                 kSTKAPIBloggerRequestKeyAPIKey:bloggerAPIKey};
    NSString *path = [self pathWithRoute:kSTKAPIBloggerRoutePosts];

    [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
        NSArray *posts = responseObject[kSTKAPIBloggerResponseKeyItems];

        if (completion) {
            completion(posts, error, self.sourceType);
        }
    }];
}

- (void)searchPostsWithText:(NSString *)text completion:(STKAPICompletion)completion {
    if (completion) {
        completion(nil, nil, self.sourceType);
    }
    //    [self.searchTask cancel];
    //
    //    if (text.length > 0) {
    //        NSDictionary *parameters = @{kSTKAPIWordpressRequestKeyFilter:@{kSTKAPIWordpressRequestKeySearch:text,
    //                                                                       kSTKAPIWordpressRequestKeyPostsPerPage:@(kSTKWordpressSessionManagerPostsPerPage)}};
    //
    //        NSString *path = [self pathWithRoute:kSTKAPIWordpressRoutePosts];
    //
    //        NSURLSessionDataTask *searchTask = [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
    //            NSArray *posts = [STKSource prefixedArrayOfPostDictionariesFromArray:responseObject type:self.type];
    //
    //            if (completion) {
    //                completion(posts, error, self.type);
    //            }
    //        }];
    //
    //        self.searchTask = searchTask;
    //    }
}

- (void)cancelPreviousPostSearches {
//    [self.searchTask cancel];
}

- (void)getCommentsForPost:(STKPost *)post completion:(STKAPICompletion)completion {
    NSString *postID = [post.postID componentsSeparatedByString:@"_"].lastObject;
    NSNumber *blogID = self.blogID ? @(self.blogID.longLongValue) : @(0);
    StackKeys *keys = [[StackKeys alloc] init];
    NSString *bloggerAPIKey = keys.bloggerAPIKey ?: @"";

    NSDictionary *parameters = @{kSTKAPIBloggerRequestKeyBlogID:blogID,
                                 kSTKAPIBloggerRequestKeyPostID:postID,
                                 kSTKAPIBloggerRequestKeyStatus:KSTKAPIBloggerRequestValueStatus,
                                 kSTKAPIBloggerRequestKeyFetchBodies:@"true",
                                 kSTKAPIBloggerRequestKeyAPIKey:bloggerAPIKey};
    NSString *path = [self pathWithRoute:[NSString stringWithFormat:kSTKAPIBloggerRoutePostComments, postID]];

    [self GET:path parameters:parameters completion:^(id responseObject, NSError *error) {
        NSArray *comments = responseObject[@"items"];
        
        if (completion) {
            completion(comments, error, self.sourceType);
        }
    }];
}

@end
