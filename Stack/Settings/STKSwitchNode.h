//
//  STKSwitchNode.h
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface STKSwitchNode : ASDisplayNode

- (void)addTarget:(id)target action:(SEL)action;

@property (assign, nonatomic) BOOL on;

@end
