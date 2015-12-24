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

#import "NSNumber+STKCGFloat.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <pop/POP.h>
#import <RZUtils/UIImage+RZSolidColor.h>

@interface STKPostFeatureImageNode () <ASNetworkImageNodeDelegate>

@property (strong, nonatomic) ASNetworkImageNode *featureNetworkImageNode;

@property (assign, nonatomic) CGSize attachmentSize;
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
    CGFloat ratio = (self.attachmentSize.width / constrainedSize.width) ?: 1.0f;
    CGFloat height = self.attachmentSize.height / ratio;
    CGSize featureNetworkImageSize = CGSizeMake(constrainedSize.width, height);

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
    self.attachmentSize = CGSizeMake(attachment.width.CGFloatValue, attachment.height.CGFloatValue);

    NSURL *URL = attachment.sourceURL ? [NSURL URLWithString:attachment.sourceURL] : nil;
    self.featureNetworkImageNode.URL = URL;
}

- (void)setupFeatureNetworkImageNode {
    self.featureNetworkImageNode = [[ASNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    self.featureNetworkImageNode.delegate = self;
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

#pragma mark - Network Image Node Delegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    imageNode.alpha = 0.0f;
}

- (void)imageNodeDidFinishDecoding:(ASNetworkImageNode *)imageNode {
    POPBasicAnimation *animation = [imageNode pop_animationForKey:@"fade_animation"];
    if (!animation) {
        animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    }

    animation.fromValue = @(imageNode.alpha);
    animation.toValue = @1.0f;
    animation.duration = 1.0;

    [imageNode pop_addAnimation:animation forKey:@"fade_animation"];
}

@end
