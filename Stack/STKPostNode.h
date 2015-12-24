//
//  STKPostNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "STKPost.h"

@interface STKPostNode : ASCellNode

- (void)setupWithPost:(STKPost *)post;

@end
