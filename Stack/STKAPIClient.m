//
//  STKAPIClient.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAPIClient.h"
#import "STKWordpressSessionManager.h"
#import "STKBloggerSessionManager.h"
#import "STKRSSSessionManager.h"

#import "STKPost.h"
#import "STKAuthor.h"

@interface STKAPIClient ()

@property (strong, nonatomic) NSDictionary *sessionManagers;

@property (strong, nonatomic) NSURLRequest *searchRequest;
@property (strong, nonatomic) NSMutableSet *cancelledSearchRequests;

@end

@implementation STKAPIClient

#pragma mark - Lifecycle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        self.sessionManagers = @{@(STKSourceTypeSkyd):[[STKWordpressSessionManager alloc] initWithSourceType:STKSourceTypeSkyd],
                                 @(STKSourceTypeBamaSecs):[[STKWordpressSessionManager alloc] initWithSourceType:STKSourceTypeBamaSecs],
                                 @(STKSourceTypeMLU):[[STKWordpressSessionManager alloc] initWithSourceType:STKSourceTypeMLU],
                                 @(STKSourceTypeUltiworld):[[STKRSSSessionManager alloc] initWithSourceType:STKSourceTypeUltiworld],
                                 @(STKSourceTypeAUDL):[[STKRSSSessionManager alloc] initWithSourceType:STKSourceTypeAUDL],
                                 @(STKSourceTypeSludge):[[STKBloggerSessionManager alloc] initWithBlogID:kSTKAPIBloggerIDSludge sourceType:STKSourceTypeSludge]};

        self.cancelledSearchRequests = [NSMutableSet set];
    }

    return self;
}

#pragma mark - Actions

- (void)getPostsBeforePost:(STKPost *)post
                    author:(STKAuthor *)author
                sourceType:(STKSourceType)sourceType
                completion:(STKAPICompletion)completion {
    id <STKSessionManagerProtocol> sessionManager = self.sessionManagers[@(sourceType)];

    if ([sessionManager conformsToProtocol:@protocol(STKSessionManagerProtocol)]) {
        [sessionManager getPostsBeforePost:post author:author completion:completion];
    }
}

- (void)searchPostsWithText:(NSString *)text completion:(STKAPICompletion)completion {
    NSArray *sessionManagers = self.sessionManagers.allValues;
    for (id <STKSessionManagerProtocol> sessionManager in sessionManagers) {
        [sessionManager searchPostsWithText:text completion:completion];
    }
}

- (void)getCommentsForPost:(STKPost *)post completion:(STKAPICompletion)completion {
    id <STKSessionManagerProtocol> sessionManager = self.sessionManagers[post.sourceType];

    if ([sessionManager conformsToProtocol:@protocol(STKSessionManagerProtocol)]) {
        [sessionManager getCommentsForPost:post completion:completion];
    }
}

@end
