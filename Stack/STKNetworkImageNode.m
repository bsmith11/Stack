//
//  STKNetworkImageNode.m
//  Stack
//
//  Created by Bradley Smith on 1/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKNetworkImageNode.h"

#import <RZUtils/UIImage+RZSolidColor.h>
#import <pop/POP.h>
#import <tgmath.h>

@interface STKNetworkImageNode () <ASNetworkImageNodeDelegate>

@property (strong, nonatomic) CALayer *stk_placeholderLayer;

@end

@implementation STKNetworkImageNode

#pragma mark - Lifecycle

- (instancetype)initWithCache:(id<ASImageCacheProtocol>)cache downloader:(id<ASImageDownloaderProtocol>)downloader {
    self = [super initWithCache:cache downloader:downloader];

    if (self) {
        self.stk_placeholderEnabled = YES;
        self.delegate = self;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];

    if (self.stk_placeholderEnabled) {
        self.stk_placeholderLayer = [CALayer layer];
        self.stk_placeholderLayer.zPosition = 9999.0f;
    }
}

- (UIColor *)stk_placeholderColor {
    if (!_stk_placeholderColor) {
        _stk_placeholderColor = [UIColor whiteColor];
    }

    return _stk_placeholderColor;
}

#pragma mark - Layout

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculatedSize = CGSizeZero;

    if (!CGSizeEqualToSize(self.staticImageSize, CGSizeZero)) {
        calculatedSize = self.staticImageSize;
    }
    else {
        CGFloat ratio = (self.originalImageSize.width / constrainedSize.width) ?: 1.0f;
        CGFloat height = (self.originalImageSize.height / ratio) ?: 200.0f;

        calculatedSize = CGSizeMake(constrainedSize.width, __tg_ceil(height));
    }

    if (self.stk_placeholderEnabled && calculatedSize.width > 0.0f && calculatedSize.height > 0.0f) {
        if (!self.stk_placeholderImage) {
            UIImage *image = [UIImage rz_solidColorImageWithSize:calculatedSize color:self.stk_placeholderColor];
            if (self.imageModificationBlock) {
                image = self.imageModificationBlock(image);
            }

            self.stk_placeholderImage = image;
        }

        if (self.stk_placeholderLayer) {
            self.stk_placeholderLayer.contents = (id)self.stk_placeholderImage.CGImage;
        }
    }

    return calculatedSize;
}

- (void)layout {
    if (self.stk_placeholderEnabled) {
        self.stk_placeholderLayer.frame = self.bounds;
    }
}

- (void)displayWillStart {
    [super displayWillStart];

    if (self.stk_placeholderEnabled && self.stk_placeholderImage && self.stk_placeholderLayer && self.layer.contents == nil) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.stk_placeholderLayer.contents = (id)self.stk_placeholderImage.CGImage;
        self.stk_placeholderLayer.opacity = 1.0;
        [CATransaction commit];
        
        [self.layer addSublayer:self.stk_placeholderLayer];
    }
}

- (void)clearContents {
    [super clearContents];

    self.stk_placeholderLayer.contents = nil;
    self.stk_placeholderImage = nil;
}

#pragma mark - Network Image Node Delegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {

}

- (void)imageNodeDidFinishDecoding:(ASNetworkImageNode *)imageNode {
    if (self.stk_placeholderEnabled) {
        POPBasicAnimation *animation = [self.stk_placeholderLayer pop_animationForKey:@"fade_animation"];
        if (!animation) {
            animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        }

        animation.fromValue = @(self.stk_placeholderLayer.opacity);
        animation.toValue = @0.0f;
        animation.duration = 0.75;
        animation.completionBlock = ^(POPAnimation *popAnimation, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.stk_placeholderLayer removeFromSuperlayer];
            });
        };

        [self.stk_placeholderLayer pop_addAnimation:animation forKey:@"fade_animation"];
    }
}

@end
