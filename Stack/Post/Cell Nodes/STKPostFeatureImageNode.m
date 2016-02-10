//
//  STKPostFeatureImageNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostFeatureImageNode.h"

#import "STKImageCache.h"
#import "STKImageDownloader.h"
#import "STKAttachment.h"

#import "STKNetworkImageNode.h"
#import "NSNumber+STKCGFloat.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKPostFeatureImageNode ()

@property (strong, nonatomic) STKNetworkImageNode *featureNetworkImageNode;

@property (assign, nonatomic) CGRect featureNetworkImageFrame;

@end

@implementation STKPostFeatureImageNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];

        [self setupFeatureNetworkImageNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGSize featureNetworkImageSize = [self.featureNetworkImageNode measure:constrainedSize];

    //Positioning
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;

    self.featureNetworkImageFrame = CGRectMake(x, y, featureNetworkImageSize.width, featureNetworkImageSize.height);

    return CGSizeMake(constrainedSize.width, CGRectGetHeight(self.featureNetworkImageFrame));
}

- (void)layout {
    self.featureNetworkImageNode.frame = self.featureNetworkImageFrame;
}

#pragma mark - Setup

- (void)setupWithAttachment:(STKAttachment *)attachment {
    self.featureNetworkImageNode.originalImageSize = CGSizeMake(attachment.width.CGFloatValue, attachment.height.CGFloatValue);

    NSURL *URL = attachment.sourceURL ? [NSURL URLWithString:attachment.sourceURL] : nil;
    self.featureNetworkImageNode.URL = URL;
}

- (void)setupFeatureNetworkImageNode {
    self.featureNetworkImageNode = [[STKNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    self.featureNetworkImageNode.contentMode = UIViewContentModeScaleAspectFill;
    [self.featureNetworkImageNode addTarget:self action:@selector(didSelectFeatureNetworkImageNode) forControlEvents:ASControlNodeEventTouchUpInside];

    [self addSubnode:self.featureNetworkImageNode];
}

#pragma mark - Actions

- (void)didSelectFeatureNetworkImageNode {
    if ([self.delegate respondsToSelector:@selector(postFeatureImageNodeDidSelectAttachment:)]) {
        [self.delegate postFeatureImageNodeDidSelectAttachment:self];
    }
}

@end
