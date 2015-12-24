//
//  UIImage+STKResize.m
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "UIImage+STKResize.h"

#import <tgmath.h>

@implementation UIImage (STKResize)

+ (UIImage *)stk_image:(UIImage *)image scaleAspectFillToSize:(CGSize)size {
    CGSize scaledSize;
    CGFloat modifier;

    if (image.size.width < image.size.height) {
        modifier = size.width / image.size.width;
        CGFloat newHeight = image.size.height * modifier;
        scaledSize.width = __tg_ceil(size.width);
        scaledSize.height = __tg_ceil(newHeight);
    }
    else {
        modifier = size.height / image.size.height;
        CGFloat newWidth = image.size.width * modifier;
        scaledSize.height = __tg_ceil(size.height);
        scaledSize.width = __tg_ceil(newWidth);
    }

    UIGraphicsBeginImageContextWithOptions(scaledSize, NO, image.scale);
    [image drawInRect:CGRectMake(0.0f, 0.0f, scaledSize.width, scaledSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;
}

@end
