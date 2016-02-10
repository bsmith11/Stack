//
//  STKPostSectionNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKPostSection, STKPostSectionNode;

@protocol STKPostSectionNodeDelegate <NSObject>

@optional
- (void)postSectionNode:(STKPostSectionNode *)node didTapLink:(NSURL *)link;
- (void)postSectionNode:(STKPostSectionNode *)node didTapImageWithURL:(NSURL *)URL size:(CGSize)size;

@end

@interface STKPostSectionNode : ASCellNode

@property (weak, nonatomic) id <STKPostSectionNodeDelegate> delegate;

@end
