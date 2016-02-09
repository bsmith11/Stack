//
//  UICollectionReusableView+STKReuse.m
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "UICollectionReusableView+STKReuse.h"

@implementation UICollectionReusableView (STKReuse)

+ (NSString *)stk_reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
