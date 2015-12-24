//
//  STKAuthorNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKAuthor, STKAuthorNode;

@protocol STKAuthorNodeDelegate <NSObject>

@optional
- (void)authorNode:(STKAuthorNode *)node didTapLink:(NSURL *)link;
- (void)authorNode:(STKAuthorNode *)node didTapImageWithURL:(NSURL *)URL size:(CGSize)size;

@end

@interface STKAuthorNode : ASCellNode

- (void)setupWithAuthor:(STKAuthor *)author;

@property (weak, nonatomic) id <STKAuthorNodeDelegate> delegate;

@end
