//
//  STKSourceListNode.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface STKSourceListNode : ASCellNode

- (void)setupWithSourceType:(STKSourceType)sourceType selected:(BOOL)selected;

@end
