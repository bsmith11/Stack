//
//  STKBaseURLSessionManager.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "STKAPIConstants.h"

@interface STKBaseURLSessionManager : AFHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url;

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters completion:(STKAPIURLSessionCompletion)completion;

@end
