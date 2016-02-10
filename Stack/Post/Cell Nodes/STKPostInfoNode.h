//
//  STKPostInfoNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKPost, STKPostInfoNode;

@protocol STKPostInfoNodeDelegate <NSObject>

- (void)postInfoNodeDidSelectAuthor:(STKPostInfoNode *)node;

@end

@interface STKPostInfoNode : ASCellNode

- (void)setupWithPost:(STKPost *)post;

@property (weak, nonatomic) id <STKPostInfoNodeDelegate> delegate;

@end
