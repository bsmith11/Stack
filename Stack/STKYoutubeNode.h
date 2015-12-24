//
//  STKYoutubeNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class YTPlayerView;

@interface STKYoutubeNode : ASDisplayNode

- (void)loadWithVideoID:(NSString *)videoID;

@property (strong, nonatomic, readonly) YTPlayerView *playerView;

@end
