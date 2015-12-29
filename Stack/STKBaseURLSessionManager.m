//
//  STKBaseURLSessionManager.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBaseURLSessionManager.h"

#import "STKAnalyticsManager.h"

@implementation STKBaseURLSessionManager

#pragma mark - Lifecycle

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];

    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters completion:(STKAPIURLSessionCompletion)completion {
    return [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (error.code != NSURLErrorCancelled) {
            [STKAnalyticsManager logEventDidFailRequest:task.originalRequest error:error];
        }

        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
