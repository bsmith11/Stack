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
//                                 @(STKSourceTypeUltiworld):[[STKRSSSessionManager alloc] initWithSourceType:STKSourceTypeUltiworld],
                                 @(STKSourceTypeAUDL):[[STKRSSSessionManager alloc] initWithSourceType:STKSourceTypeAUDL],
                                 @(STKSourceTypeSludge):[[STKBloggerSessionManager alloc] initWithBlogID:kSTKAPIBloggerIDSludge sourceType:STKSourceTypeSludge],
                                 @(STKSourceTypeProcessOfIllumination):[[STKBloggerSessionManager alloc] initWithBlogID:kSTKAPIBloggerIDProcessOfIllumination sourceType:STKSourceTypeProcessOfIllumination],
                                 @(STKSourceTypeGetHorizontal):[[STKRSSSessionManager alloc] initWithSourceType:STKSourceTypeGetHorizontal]};

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

- (void)searchPostsWithText:(NSString *)text
                 sourceType:(STKSourceType)sourceType
                 completion:(STKAPICompletion)completion {
    id <STKSessionManagerProtocol> sessionManager = self.sessionManagers[@(sourceType)];

    if ([sessionManager conformsToProtocol:@protocol(STKSessionManagerProtocol)]) {
        [sessionManager searchPostsWithText:text completion:completion];
    }
}

- (void)cancelPreviousPostSearches {
    for (id <STKSessionManagerProtocol> sessionManager in self.sessionManagers) {
        if ([sessionManager conformsToProtocol:@protocol(STKSessionManagerProtocol)]) {
            [sessionManager cancelPreviousPostSearches];
        }
    }
}

- (void)getCommentsForPost:(STKPost *)post completion:(STKAPICompletion)completion {
    id <STKSessionManagerProtocol> sessionManager = self.sessionManagers[post.sourceType];

    if ([sessionManager conformsToProtocol:@protocol(STKSessionManagerProtocol)]) {
        [sessionManager getCommentsForPost:post completion:completion];
    }
}

- (void)getEventsWithCompletion:(void (^)(id, NSError *))completion {
    STKBaseURLSessionManager *sessionManager = [[STKBaseURLSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://play.usaultimate.org/"]];

    NSDictionary *parameters = @{@"f":@"GETALLEVENTS"};
    [sessionManager GET:@"/ajax/api.aspx" parameters:parameters completion:completion];
}

- (void)getEventWithID:(NSNumber *)eventID completion:(void (^)(id, NSError *))completion {
    STKBaseURLSessionManager *sessionManager = [[STKBaseURLSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://play.usaultimate.org/"]];

    NSDictionary *parameters = @{@"f":@"GETGAMESBYEVENT",
                                 @"EventId":eventID};
    [sessionManager GET:@"/ajax/api.aspx" parameters:parameters completion:completion];
}

@end
