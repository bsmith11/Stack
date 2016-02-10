//
//  STKImageCache.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import <AsyncDisplayKit/ASImageProtocols.h>

@interface STKImageCache : NSObject <ASImageCacheProtocol>

+ (instancetype)sharedInstance;

- (UIImage *)imageForURL:(NSURL *)URL;
- (void)storeImage:(UIImage *)image URL:(NSURL *)URL completion:(void (^)(NSError *error))completion;

@end
