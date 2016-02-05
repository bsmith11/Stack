//
//  UITableViewCell+STKReuse.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "UITableViewCell+STKReuse.h"

@implementation UITableViewCell (STKReuse)

+ (NSString *)stk_reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
