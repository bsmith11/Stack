//
//  ASImageNode+STKModificationBlocks.h
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface ASImageNode (STKModificationBlocks)

asimagenode_modification_block_t STKImageNodeCornerRadiusModificationBlock(CGFloat cornerRadius);

@end
