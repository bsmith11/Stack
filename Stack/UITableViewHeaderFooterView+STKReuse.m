//
//  UITableViewHeaderFooterView+STKReuse.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "UITableViewHeaderFooterView+STKReuse.h"

@implementation UITableViewHeaderFooterView (STKReuse)

+ (NSString *)stk_reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
