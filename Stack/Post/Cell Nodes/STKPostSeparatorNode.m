//
//  STKPostSeparatorNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostSeparatorNode.h"

#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKPostSeparatorNode ()

@property (strong, nonatomic) ASDisplayNode *separatorNode;

@property (assign, nonatomic) CGRect separatorNodeFrame;

@end

@implementation STKPostSeparatorNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupSeparatorNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGSize separatorSize = CGSizeMake(50.0f, 1.0f);

    //Positioning
    CGFloat x = 25.0f;
    CGFloat y = 12.5f;

    self.separatorNodeFrame = CGRectMake(x, y, separatorSize.width, separatorSize.height);

    return CGSizeMake(constrainedSize.width, CGRectGetHeight(self.separatorNodeFrame) + 25.0f);
}

- (void)layout {
    self.separatorNode.frame = self.separatorNodeFrame;
}

#pragma mark - Setup

- (void)setupSeparatorNode {
    self.separatorNode = [[ASDisplayNode alloc] init];
    self.separatorNode.layerBacked = YES;
    self.separatorNode.backgroundColor = [UIColor stk_stackColor];

    [self addSubnode:self.separatorNode];
}

@end
