//
//  STKUnavailableNode.h
//  Stack
//
//  Created by Bradley Smith on 1/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKUnavailableNode;

@protocol STKUnavailableNodeDelegate <NSObject>

- (void)unavailableNodeDidTapAction:(STKUnavailableNode *)node;

@end

@interface STKUnavailableNode : ASCellNode

- (void)setupWithImage:(UIImage *)image
                 title:(NSString *)title
               message:(NSString *)message
                action:(NSString *)action
              delegate:(id <STKUnavailableNodeDelegate>)delegate;

@end
