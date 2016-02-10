//
//  STKPostImageSectionNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostImageSectionNode.h"

#import "STKPostImageSection.h"

#import "STKNetworkImageNode.h"
#import "STKImageCache.h"
#import "STKImageDownloader.h"
#import "NSNumber+STKCGFloat.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKPostImageSectionNode ()

@property (strong, nonatomic) STKNetworkImageNode *sectionNetworkImageNode;

@property (assign, nonatomic) CGRect sectionNetworkImageNodeFrame;

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
    CGSize sectionNetworkImageSize = [self.sectionNetworkImageNode measure:constrainedSize];

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
    self.sectionNetworkImageNode.originalImageSize = CGSizeMake(section.width.CGFloatValue, section.height.CGFloatValue);

    NSURL *URL = section.sourceURL ? [NSURL URLWithString:section.sourceURL] : nil;
    self.sectionNetworkImageNode.URL = URL;
}

- (void)setupSectionNetworkImageNode {
    self.sectionNetworkImageNode = [[STKNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    [self.sectionNetworkImageNode addTarget:self action:@selector(imageNodeTapped) forControlEvents:ASControlNodeEventTouchUpInside];
    self.sectionNetworkImageNode.userInteractionEnabled = YES;
    self.sectionNetworkImageNode.contentMode = UIViewContentModeScaleAspectFill;

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

@end
