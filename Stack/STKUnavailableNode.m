//
//  STKUnavailableNode.m
//  Stack
//
//  Created by Bradley Smith on 1/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKUnavailableNode.h"

#import "STKAttributes.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKUnavailableNode ()

@property (strong, nonatomic) ASImageNode *imageNode;
@property (strong, nonatomic) ASTextNode *titleTextNode;
@property (strong, nonatomic) ASTextNode *messageTextNode;
@property (strong, nonatomic) ASTextNode *actionTextNode;

@property (weak, nonatomic) id <STKUnavailableNodeDelegate> delegate;

@property (assign, nonatomic) CGRect imageNodeFrame;
@property (assign, nonatomic) CGRect titleTextNodeFrame;
@property (assign, nonatomic) CGRect messageTextNodeFrame;
@property (assign, nonatomic) CGRect actionTextNodeFrame;

@end

@implementation STKUnavailableNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        [self setupImageNode];
        [self setupTitleTextNode];
        [self setupMessageTextNode];
        [self setupActionTextNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGSize imageNodeSize = CGSizeMake(150.0f, 150.0f);

    CGSize titleConstrainedSize = CGSizeMake(constrainedSize.width - 50.0f, constrainedSize.height);
    CGSize titleSize = [self.titleTextNode measure:titleConstrainedSize];

    CGSize messageConstrainedSize = CGSizeMake(constrainedSize.width - 50.0f, constrainedSize.height);
    CGSize messageSize = [self.messageTextNode measure:messageConstrainedSize];

    CGSize actionConstrainedSize = CGSizeMake(constrainedSize.width - 50.0f, constrainedSize.height);
    CGSize actionSize = [self.actionTextNode measure:actionConstrainedSize];

    //Positioning
    CGFloat x = (constrainedSize.width - imageNodeSize.width) / 2;
    CGFloat y = 25.0f;

    self.imageNodeFrame = CGRectMake(x, y, imageNodeSize.width, imageNodeSize.height);

    x = (constrainedSize.width - titleSize.width) / 2;
    y = CGRectGetMaxY(self.imageNodeFrame) + 50.0f;

    self.titleTextNodeFrame = CGRectMake(x, y, titleSize.width, titleSize.height);

    x = (constrainedSize.width - messageSize.width) / 2;
    y = CGRectGetMaxY(self.titleTextNodeFrame) + 12.5f;

    self.messageTextNodeFrame = CGRectMake(x, y, messageSize.width, messageSize.height);

    x = (constrainedSize.width - actionSize.width) / 2;
    y = CGRectGetMaxY(self.messageTextNodeFrame) + 25.0f;

    self.actionTextNodeFrame = CGRectMake(x, y, actionSize.width, actionSize.height);

    return CGSizeMake(constrainedSize.width, CGRectGetMaxY(self.actionTextNodeFrame) + 25.0f);
}

- (void)layout {
    self.imageNode.frame = self.imageNodeFrame;
    self.titleTextNode.frame = self.titleTextNodeFrame;
    self.messageTextNode.frame = self.messageTextNodeFrame;
    self.actionTextNode.frame = self.actionTextNodeFrame;
}

#pragma mark - Setup

- (void)setupWithImage:(UIImage *)image
                 title:(NSString *)title
               message:(NSString *)message
                action:(NSString *)action
              delegate:(id <STKUnavailableNodeDelegate>)delegate {
    self.imageNode.image = image;

    title = title ?: @"";
    self.titleTextNode.attributedString = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_emptyStateTitleAttributes]];

    message = message ?: @"";
    self.messageTextNode.attributedString = [[NSAttributedString alloc] initWithString:message attributes:[STKAttributes stk_emptyStateMessageAttributes]];

    action = action ?: @"";
    self.actionTextNode.attributedString = [[NSAttributedString alloc] initWithString:action attributes:[STKAttributes stk_emptyStateActionAttributes]];

    self.delegate = delegate;
}

- (void)setupImageNode {
    self.imageNode = [[ASImageNode alloc] init];
    self.imageNode.layerBacked = YES;
    self.imageNode.contentMode = UIViewContentModeCenter;
    self.imageNode.placeholderEnabled = YES;

    [self addSubnode:self.imageNode];
}

- (void)setupTitleTextNode {
    self.titleTextNode = [[ASTextNode alloc] init];
    self.titleTextNode.layerBacked = YES;
    self.titleTextNode.placeholderEnabled = YES;

    [self addSubnode:self.titleTextNode];
}

- (void)setupMessageTextNode {
    self.messageTextNode = [[ASTextNode alloc] init];
    self.messageTextNode.layerBacked = YES;
    self.messageTextNode.placeholderEnabled = YES;

    [self addSubnode:self.messageTextNode];
}

- (void)setupActionTextNode {
    self.actionTextNode = [[ASTextNode alloc] init];
    self.actionTextNode.userInteractionEnabled = YES;
    self.actionTextNode.placeholderEnabled = YES;
    self.actionTextNode.hitTestSlop = UIEdgeInsetsMake(-10.0f, -10.0f, -10.0f, -10.0f);

    [self.actionTextNode addTarget:self action:@selector(didTapActionTextNode) forControlEvents:ASControlNodeEventTouchUpInside];

    [self addSubnode:self.actionTextNode];
}

#pragma mark - Actions

- (void)didTapActionTextNode {
    if ([self.delegate respondsToSelector:@selector(unavailableNodeDidTapAction:)]) {
        [self.delegate unavailableNodeDidTapAction:self];
    }
}

@end
