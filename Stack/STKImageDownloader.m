//
//  STKImageDownloader.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKImageDownloader.h"

#import "UIImage+STKResize.h"

#import <PINRemoteImage/PINRemoteImageManager.h>

NSString * const kSTKImageDownloaderProcessorKeyScaleAspectFill = @"scaleAspectFill";

@implementation STKImageDownloader

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (id)downloadImageWithURL:(NSURL *)URL
             callbackQueue:(dispatch_queue_t)callbackQueue
     downloadProgressBlock:(void (^)(CGFloat progress))downloadProgressBlock
                completion:(void (^)(CGImageRef image, NSError *error))completion {
    dispatch_queue_t newCallbackQueue = callbackQueue ?: dispatch_get_main_queue();

    PINRemoteImageManagerImageProcessor processor = ^UIImage *(PINRemoteImageManagerResult *result, NSUInteger *cost) {
        UIImage *processedImage;
        if (result.resultType == PINRemoteImageResultTypeDownload) {
            CGFloat scale = [UIScreen mainScreen].scale;

            CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds) * scale;
            CGFloat ratio = result.image.size.width / screenWidth;
            ratio = ratio ?: 1.0f;
            CGFloat scaledHeight = result.image.size.height / ratio;

            CGSize size = CGSizeMake(screenWidth, scaledHeight);
            processedImage = [UIImage stk_image:result.image scaleAspectFillToSize:size];
        }
        else {
            processedImage = nil;
        }

        return processedImage;
    };

    PINRemoteImageManagerImageCompletion downloadCompletion = ^(PINRemoteImageManagerResult *result) {
        if (result.resultType == PINRemoteImageResultTypeNone) {
            dispatch_async(newCallbackQueue, ^{
                completion(nil, result.error);
            });
        }
        else {
            dispatch_async(newCallbackQueue, ^{
                completion(result.image.CGImage, nil);
            });
        }
    };

    PINRemoteImageManager *imageManager = [PINRemoteImageManager sharedImageManager];
    NSUUID *identifier = [imageManager downloadImageWithURL:URL
                                                    options:PINRemoteImageManagerDownloadOptionsNone
                                               processorKey:kSTKImageDownloaderProcessorKeyScaleAspectFill
                                                  processor:processor
                                                 completion:downloadCompletion];

    return identifier;
}

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier {
    PINRemoteImageManager *imageManager = [PINRemoteImageManager sharedImageManager];
    NSUUID *identifier = (NSUUID *)downloadIdentifier;
    
    [imageManager cancelTaskWithUUID:identifier];
}

@end
