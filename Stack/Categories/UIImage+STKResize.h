//
//  UIImage+STKResize.h
//  Stack
//
//  Created by Bradley Smith on 12/20/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

@interface UIImage (STKResize)

+ (UIImage *)stk_image:(UIImage *)image scaleAspectFillToSize:(CGSize)size;

@end
