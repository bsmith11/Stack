//
//  ASImageNode+STKModificationBlocks.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "ASImageNode+STKModificationBlocks.h"

@implementation ASImageNode (STKModificationBlocks)

extern asimagenode_modification_block_t STKImageNodeCornerRadiusModificationBlock(CGFloat cornerRadius) {
    return ^(UIImage *originalImage) {
        UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, originalImage.scale);
        UIBezierPath *cornerRadiusOutline = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, originalImage.size} cornerRadius:cornerRadius];

        [cornerRadiusOutline addClip];
        [originalImage drawAtPoint:CGPointZero];

        UIImage *modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return modifiedImage;
    };
}

@end
