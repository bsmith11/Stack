//
//  STKBloggerSessionManager.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKBaseURLSessionManager.h"

#import "STKSessionManagerProtocol.h"

@interface STKBloggerSessionManager : STKBaseURLSessionManager <STKSessionManagerProtocol>

- (instancetype)initWithBlogID:(NSString *)blogID sourceType:(STKSourceType)sourceType;

@property (strong, nonatomic, readonly) NSString *blogID;

@end
