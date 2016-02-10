//
//  STKPostFeatureImageNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKAttachment, STKPostFeatureImageNode;

@protocol STKPostFeatureImageNodeDelegate <NSObject>

- (void)postFeatureImageNodeDidSelectAttachment:(STKPostFeatureImageNode *)node;

@end

@interface STKPostFeatureImageNode : ASCellNode

- (void)setupWithAttachment:(STKAttachment *)attachment;

@property (weak, nonatomic) id <STKPostFeatureImageNodeDelegate> delegate;

@end
