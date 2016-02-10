//
//  STKYoutubeNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKYoutubeNode.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <youtube-ios-player-helper/YTPlayerView.h>

@interface STKYoutubeNode ()

@property (copy, nonatomic) NSString *videoID;

@end

@implementation STKYoutubeNode

+ (NSDictionary *)playerVariables {
    static NSDictionary *playerVariables = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerVariables = @{@"rel":@0,
                            @"showinfo":@0};
    });

    return playerVariables;
}

+ (Class)viewClass {
    return [YTPlayerView class];
}

- (YTPlayerView *)playerView {
    return (YTPlayerView *)self.view;
}

- (void)didLoad {
    [super didLoad];

    if (self.videoID) {
        [self.playerView loadWithVideoId:self.videoID playerVars:[STKYoutubeNode playerVariables]];
        self.videoID = nil;
    }
}

- (void)loadWithVideoID:(NSString *)videoID {
    if (self.nodeLoaded) {
        [self.playerView loadWithVideoId:videoID playerVars:[STKYoutubeNode playerVariables]];
    }
    else {
        self.videoID = videoID;
    }
}

@end
