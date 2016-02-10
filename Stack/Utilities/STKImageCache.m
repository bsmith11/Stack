//
//  STKImageCache.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKImageCache.h"

#import "STKImageDownloader.h"

#import <PINRemoteImage/PINRemoteImageManager.h>
#import <PINCache/PINCache.h>

@implementation STKImageCache

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (UIImage *)imageForURL:(NSURL *)URL {
    PINRemoteImageManager *imageManager = [PINRemoteImageManager sharedImageManager];
    NSString *cacheKey = [imageManager cacheKeyForURL:URL processorKey:kSTKImageDownloaderProcessorKeyScaleAspectFill];
    id object = [imageManager.cache objectForKey:cacheKey];

    if (![object isKindOfClass:[UIImage class]]) {
        object = [UIImage imageWithData:object];
    }

    return object;
}

#pragma mark - ASImage Cache Protocol

- (void)fetchCachedImageWithURL:(NSURL *)URL
                  callbackQueue:(dispatch_queue_t)callbackQueue
                     completion:(void (^)(CGImageRef imageFromCache))completion {
    dispatch_queue_t newCallbackQueue = callbackQueue ?: dispatch_get_main_queue();
    dispatch_queue_t fetchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(fetchQueue, ^{
        if (!URL) {
            dispatch_async(newCallbackQueue, ^{
                if (completion) {
                    completion(nil);
                }
            });
        }
        else {
            PINRemoteImageManager *imageManager = [PINRemoteImageManager sharedImageManager];
            NSString *cacheKey = [imageManager cacheKeyForURL:URL processorKey:kSTKImageDownloaderProcessorKeyScaleAspectFill];
            [imageManager imageFromCacheWithCacheKey:cacheKey completion:^(PINRemoteImageManagerResult *result) {
                UIImage *image = (result.resultType == PINRemoteImageResultTypeNone) ? nil : result.image;

                dispatch_async(newCallbackQueue, ^{
                    if (completion) {
                        completion(image.CGImage);
                    }
                });
            }];
        }
    });
}

#pragma mark - Store Image

- (void)storeImage:(UIImage *)image URL:(NSURL *)URL completion:(void (^)(NSError *error))completion {
    PINRemoteImageManager *imageManager = [PINRemoteImageManager sharedImageManager];
    NSString *cacheKey = [imageManager cacheKeyForURL:URL processorKey:nil];

    [[imageManager defaultImageCache] setObject:image forKey:cacheKey block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
        if (completion) {
            if (object) {
                completion(nil);
            }
            else {
                NSError *error = [NSError errorWithDomain:@"com.bradsmith.stack.PINCache" code:0 userInfo:nil];
                completion(error);
            }
        }
    }];
}

@end
