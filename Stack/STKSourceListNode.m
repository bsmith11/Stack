//
//  STKSourceListNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSourceListNode.h"

#import "STKAttributes.h"
#import "ASImageNode+STKModificationBlocks.h"
#import "ASDisplayNode+STKShadow.h"
#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKSourceListNode ()

@property (strong, nonatomic) ASDisplayNode *containerNode;
@property (strong, nonatomic) ASImageNode *sourceImageNode;
@property (strong, nonatomic) ASTextNode *titleTextNode;
@property (strong, nonatomic) ASImageNode *checkmarkImageNode;

@property (assign, nonatomic) CGRect containerNodeFrame;
@property (assign, nonatomic) CGRect sourceImageNodeFrame;
@property (assign, nonatomic) CGRect titleTextNodeFrame;
@property (assign, nonatomic) CGRect checkmarkImageNodeFrame;

@end

@implementation STKSourceListNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = NO;

        self.neverShowPlaceholders = YES;

        [self setupContainerNode];
        [self setupSourceImageNode];
        [self setupTitleTextNode];
        [self setupCheckmarkImageNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGFloat containerNodeWidth = constrainedSize.width;

    CGSize sourceImageSize = CGSizeMake(35.0f, 35.0f);

    CGSize checkmarkImageSize = CGSizeMake(25.0f, 25.0f);

    CGSize titleConstrainedSize = CGSizeMake(containerNodeWidth - (4 * 12.5f) - sourceImageSize.width - checkmarkImageSize.width, constrainedSize.height);
    CGSize titleSize = [self.titleTextNode measure:titleConstrainedSize];

    CGFloat containerNodeHeight = MAX(sourceImageSize.height, titleSize.height) + 25.0f;
    CGSize containerSize = CGSizeMake(containerNodeWidth, containerNodeHeight);

    //Positioning
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;

    self.containerNodeFrame = CGRectMake(x, y, containerSize.width, containerSize.height);

    x = 12.5f;
    y = (CGRectGetHeight(self.containerNodeFrame) - sourceImageSize.height) / 2;

    self.sourceImageNodeFrame = CGRectMake(x, y, sourceImageSize.width, sourceImageSize.height);

    x = CGRectGetMaxX(self.sourceImageNodeFrame) + 12.5f;
    y = (CGRectGetHeight(self.containerNodeFrame) - titleSize.height) / 2;

    self.titleTextNodeFrame = CGRectMake(x, y, titleSize.width, titleSize.height);

    x = constrainedSize.width - 12.5f - checkmarkImageSize.width;
    y = (CGRectGetHeight(self.containerNodeFrame) - checkmarkImageSize.height) / 2;

    self.checkmarkImageNodeFrame = CGRectMake(x, y, checkmarkImageSize.width, checkmarkImageSize.height);

    return CGSizeMake(constrainedSize.width, CGRectGetHeight(self.containerNodeFrame));
}

- (void)layout {
    self.containerNode.frame = self.containerNodeFrame;
    self.sourceImageNode.frame = self.sourceImageNodeFrame;
    self.titleTextNode.frame = self.titleTextNodeFrame;
    self.checkmarkImageNode.frame = self.checkmarkImageNodeFrame;

    [self.containerNode stk_setupShadow];
}

#pragma mark - Setup

- (void)setupWithSourceType:(STKSourceType)sourceType selected:(BOOL)selected {
    NSString *imageName = [STKSource imageNameForType:sourceType] ?: @"App Icon";
    self.sourceImageNode.image = [UIImage imageNamed:imageName];

    NSString *name = [STKSource nameForType:sourceType] ?: @"Stack";
    self.titleTextNode.attributedString = [[NSAttributedString alloc] initWithString:name attributes:[STKAttributes stk_filterSourceAttributes]];

    self.checkmarkImageNode.hidden = !selected;
}

- (void)setupContainerNode {
    self.containerNode = [[ASDisplayNode alloc] init];
    self.containerNode.backgroundColor = [UIColor whiteColor];

    [self addSubnode:self.containerNode];
}

- (void)setupSourceImageNode {
    self.sourceImageNode = [[ASImageNode alloc] init];
    self.sourceImageNode.layerBacked = YES;
    self.sourceImageNode.contentMode = UIViewContentModeScaleAspectFit;
    self.sourceImageNode.placeholderEnabled = YES;

    [self.containerNode addSubnode:self.sourceImageNode];
}

- (void)setupTitleTextNode {
    self.titleTextNode = [[ASTextNode alloc] init];
    self.titleTextNode.layerBacked = YES;
    self.titleTextNode.placeholderEnabled = YES;

    [self.containerNode addSubnode:self.titleTextNode];
}

- (void)setupCheckmarkImageNode {
    self.checkmarkImageNode = [[ASImageNode alloc] init];
    self.checkmarkImageNode.layerBacked = YES;
    self.checkmarkImageNode.contentMode = UIViewContentModeCenter;
    self.checkmarkImageNode.placeholderEnabled = YES;
    self.checkmarkImageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock([UIColor stk_stackColor]);
    self.checkmarkImageNode.image = [UIImage imageNamed:@"Checkmark Icon"];
    
    [self.containerNode addSubnode:self.checkmarkImageNode];
}

@end
