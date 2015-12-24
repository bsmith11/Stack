//
//  STKPostTitleNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKPost;

@interface STKPostTitleNode : ASCellNode

- (void)setupWithPost:(STKPost *)post;

@end
