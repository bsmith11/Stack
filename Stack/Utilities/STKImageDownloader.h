//
//  STKImageDownloader.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

#import <AsyncDisplayKit/ASImageProtocols.h>

OBJC_EXTERN NSString * const kSTKImageDownloaderProcessorKeyScaleAspectFill;

@interface STKImageDownloader : NSObject <ASImageDownloaderProtocol>

+ (instancetype)sharedInstance;

- (id)downloadImageWithURL:(NSURL *)URL
             callbackQueue:(dispatch_queue_t)callbackQueue
     downloadProgressBlock:(void (^)(CGFloat progress))downloadProgressBlock
                completion:(void (^)(CGImageRef image, NSError *error))completion;

- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier;

@end
