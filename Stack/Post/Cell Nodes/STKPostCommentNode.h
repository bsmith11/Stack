//
//  STKPostCommentNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKPostCommentNode, STKComment;

@protocol STKPostCommentNodeDelegate <NSObject>

- (void)postCommentNode:(STKPostCommentNode *)node didTapLink:(NSURL *)link;

@end

@interface STKPostCommentNode : ASCellNode

- (void)setupWithComment:(STKComment *)comment;

@property (weak, nonatomic) id <STKPostCommentNodeDelegate> delegate;

@end
