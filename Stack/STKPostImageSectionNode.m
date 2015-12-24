//
//  STKPostImageSectionNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostImageSectionNode.h"

#import "STKPostImageSection.h"

#import "STKImageCache.h"
#import "STKImageDownloader.h"
#import "NSNumber+STKCGFloat.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <pop/POP.h>

@interface STKPostImageSectionNode () <ASNetworkImageNodeDelegate>

@property (strong, nonatomic) ASNetworkImageNode *sectionNetworkImageNode;

@property (assign, nonatomic) CGRect sectionNetworkImageNodeFrame;
@property (assign, nonatomic) CGSize imageSize;

@end

@implementation STKPostImageSectionNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupSectionNetworkImageNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGFloat ratio = (self.imageSize.width / constrainedSize.width) ?: 1.0f;
    CGFloat height = (self.imageSize.height / ratio) ?: 200.0f;

    CGSize sectionNetworkImageSize = CGSizeMake(constrainedSize.width, height);

    //Positioning
    CGFloat x = 0.0f;
    CGFloat y = 12.5f;

    self.sectionNetworkImageNodeFrame = CGRectMake(x, y, sectionNetworkImageSize.width, sectionNetworkImageSize.height);

    return CGSizeMake(constrainedSize.width, sectionNetworkImageSize.height + 25.0f);
}

- (void)layout {
    self.sectionNetworkImageNode.frame = self.sectionNetworkImageNodeFrame;
}

#pragma mark - Setup

- (void)setupWithSection:(STKPostImageSection *)section {
    self.imageSize = CGSizeMake(section.width.CGFloatValue, section.height.CGFloatValue);

    NSURL *URL = section.sourceURL ? [NSURL URLWithString:section.sourceURL] : nil;
    self.sectionNetworkImageNode.URL = URL;
}

- (void)setupSectionNetworkImageNode {
    self.sectionNetworkImageNode = [[ASNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    [self.sectionNetworkImageNode addTarget:self action:@selector(imageNodeTapped) forControlEvents:ASControlNodeEventTouchUpInside];
    self.sectionNetworkImageNode.userInteractionEnabled = YES;
    self.sectionNetworkImageNode.contentMode = UIViewContentModeScaleAspectFill;
    self.sectionNetworkImageNode.delegate = self;
    self.sectionNetworkImageNode.alpha = 0.0f;

    [self addSubnode:self.sectionNetworkImageNode];
}

#pragma mark - Actions

- (void)imageNodeTapped {
    if (self.sectionNetworkImageNode.URL) {
        if ([self.delegate respondsToSelector:@selector(postSectionNode:didTapImageWithURL:size:)]) {
            [self.delegate postSectionNode:self didTapImageWithURL:self.sectionNetworkImageNode.URL size:self.sectionNetworkImageNode.frame.size];
        }
    }
}

- (CGRect)imageNodeFrame {
    return self.sectionNetworkImageNode.frame;
}

#pragma mark - Network Image Node Delegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {

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
