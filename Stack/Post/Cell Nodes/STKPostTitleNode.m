//
//  STKPostTitleNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostTitleNode.h"

#import "STKPost.h"

#import "STKAttributes.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKPostTitleNode ()

@property (strong, nonatomic) ASTextNode *titleTextNode;

@end

@implementation STKPostTitleNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupTitleTextNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize titleTextConstrainedSize = CGSizeMake(constrainedSize.width - 50.0f, constrainedSize.height);
    CGSize titleTextSize = [self.titleTextNode measure:titleTextConstrainedSize];

    return CGSizeMake(constrainedSize.width, titleTextSize.height + 37.5f);
}

- (void)layout {
    CGFloat x = 25.0f;
    CGFloat y = 25.0f;
    CGFloat width = self.titleTextNode.calculatedSize.width;
    CGFloat height = self.titleTextNode.calculatedSize.height;

    self.titleTextNode.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Setup

- (void)setupWithPost:(STKPost *)post {
    NSString *title = post.title ?: @"No title";
    self.titleTextNode.attributedString = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_postTitleAttributes]];
}

- (void)setupTitleTextNode {
    self.titleTextNode = [[ASTextNode alloc] init];
    self.titleTextNode.layerBacked = YES;
    self.titleTextNode.placeholderEnabled = YES;

    [self addSubnode:self.titleTextNode];
}

@end
