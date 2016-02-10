//
//  STKPostVideoSectionNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostVideoSectionNode.h"

#import "STKPostVideoSection.h"
#import "STKHTMLVideoSection.h"

#import "STKYoutubeNode.h"
#import "STKWebNode.h"

#import "STKImageCache.h"
#import "NSString+STKHTML.h"
#import "NSNumber+STKCGFloat.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <youtube-ios-player-helper/YTPlayerView.h>

@interface STKPostVideoSectionNode ()

@property (strong, nonatomic) STKWebNode *webNode;
@property (strong, nonatomic) STKYoutubeNode *youtubeNode;

@property (assign, nonatomic) CGRect webNodeFrame;
@property (assign, nonatomic) CGRect youtubeNodeFrame;

@property (assign, nonatomic) CGSize videoSize;

@end

@implementation STKPostVideoSectionNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {

    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGFloat ratio = (self.videoSize.width / constrainedSize.width) ?: 1.0f;
    CGFloat height = (self.videoSize.height / ratio) ?: 200.0f;

    CGSize videoSize = CGSizeMake(constrainedSize.width, height);

    //Positioning
    CGFloat x = 0.0f;
    CGFloat y = 12.5f;

    self.webNodeFrame = CGRectMake(x, y, videoSize.width, videoSize.height);
    self.youtubeNodeFrame = CGRectMake(x, y, videoSize.width, videoSize.height);

    return CGSizeMake(constrainedSize.width, videoSize.height + 25.0f);
}

- (void)layout {
    if (self.webNode) {
        self.webNode.frame = self.webNodeFrame;
    }
    else if (self.youtubeNode) {
        self.youtubeNode.frame = self.youtubeNodeFrame;
        self.youtubeNode.playerView.webView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.youtubeNodeFrame), CGRectGetHeight(self.youtubeNodeFrame));
    }
}

#pragma mark - Setup

- (void)setupWithSection:(STKPostVideoSection *)section {
    self.videoSize = CGSizeMake(section.width.CGFloatValue, section.height.CGFloatValue);

    switch (section.type.integerValue) {
        case STKHTMLVideoSectionTypeYoutube: {
            [self.webNode removeFromSupernode];
            self.webNode = nil;
            [self setupYoutubeNode];

            NSString *videoID = [section.sourceURL stk_youtubeVideoID];
            [self.youtubeNode loadWithVideoID:videoID];
        }
            break;

        case STKHTMLVideoSectionTypeSoundcloud: { //This case falls through
            self.videoSize = CGSizeMake(self.videoSize.width, 0.0f);
        }

        case STKHTMLVideoSectionTypeVimeo:
        case STKHTMLVideoSectionTypeOther: {
            [self.youtubeNode removeFromSupernode];
            self.youtubeNode = nil;
            [self setupWebNode];

            NSURL *URL = section.sourceURL.length > 0 ? [NSURL URLWithString:section.sourceURL] : nil;
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
            [self.webNode loadRequest:request];
        }
            break;
    }
}

- (void)setupWebNode {
    self.webNode = [[STKWebNode alloc] init];

    [self addSubnode:self.webNode];
}

- (void)setupYoutubeNode {
    self.youtubeNode = [[STKYoutubeNode alloc] init];
    
    [self addSubnode:self.youtubeNode];
}

@end
