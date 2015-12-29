//
//  STKSettingsItemNode.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSettingsItemNode.h"

#import "STKSettingsItem.h"

#import "STKAttributes.h"
#import "ASDisplayNode+STKShadow.h"

#import "STKSwitchNode.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKSettingsItemNode ()

@property (strong, nonatomic) ASDisplayNode *containerNode;
@property (strong, nonatomic) ASImageNode *imageNode;
@property (strong, nonatomic) ASTextNode *titleTextNode;
@property (strong, nonatomic) ASDisplayNode *accessoryContainerNode;

@property (strong, nonatomic) ASImageNode *accessoryImageNode;
@property (strong, nonatomic) STKSwitchNode *accessorySwitchNode;

@property (assign, nonatomic) CGRect containerNodeFrame;
@property (assign, nonatomic) CGRect imageNodeFrame;
@property (assign, nonatomic) CGRect titleTextNodeFrame;
@property (assign, nonatomic) CGRect accessoryContainerNodeFrame;

@property (assign, nonatomic) CGRect accessoryImageNodeFrame;
@property (assign, nonatomic) CGRect accessorySwitchNodeFrame;

@property (assign, nonatomic) STKSettingsItemType type;

@end

@implementation STKSettingsItemNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = NO;
        self.neverShowPlaceholders = YES;

        [self setupContainerNode];
        [self setupImageNode];
        [self setupTitleTextNode];
        [self setupAccessoryContainerNode];

        [self setupAccessoryImageNode];
        [self setupAccessorySwitchNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGFloat containerWidth = constrainedSize.width;

    CGSize imageNodeSize = CGSizeMake(31.0f, 31.0f);

    [self configureAccessoryContainerNodeWithType:self.type];
    CGSize accessoryContainerSize = [self accessoryContainerSizeForType:self.type];

    CGSize titleConstrainedSize = CGSizeMake(containerWidth - (4 * 12.5f) - imageNodeSize.width - accessoryContainerSize.width, constrainedSize.height);
    CGSize titleSize = [self.titleTextNode measure:titleConstrainedSize];

    CGFloat containerHeight = 31.0f + (2 * 12.5f);
    CGSize containerSize = CGSizeMake(containerWidth, containerHeight);

    //Positioning
    CGFloat x = 12.5f;
    CGFloat y = (containerSize.height - imageNodeSize.height) / 2;

    self.imageNodeFrame = CGRectMake(x, y, imageNodeSize.width, imageNodeSize.height);

    x = CGRectGetMaxX(self.imageNodeFrame) + 12.5f;
    y = (containerSize.height - titleSize.height) / 2;

    self.titleTextNodeFrame = CGRectMake(x, y, titleSize.width, titleSize.height);

    x = containerSize.width - 12.5f - accessoryContainerSize.width;
    y = (containerSize.height - accessoryContainerSize.height) / 2;

    self.accessoryContainerNodeFrame = CGRectMake(x, y, accessoryContainerSize.width, accessoryContainerSize.height);

    x = 0.0f;
    y = 0.0f;

    self.containerNodeFrame = CGRectMake(x, y, containerSize.width, containerSize.height);

    return CGSizeMake(constrainedSize.width, containerSize.height);
}

- (void)layout {
    self.containerNode.frame = self.containerNodeFrame;
    self.imageNode.frame = self.imageNodeFrame;
    self.titleTextNode.frame = self.titleTextNodeFrame;
    self.accessoryContainerNode.frame = self.accessoryContainerNodeFrame;

    self.accessoryImageNode.frame = self.accessoryImageNodeFrame;
    self.accessorySwitchNode.frame = self.accessorySwitchNodeFrame;

    [self.containerNode stk_setupShadow];
}

- (CGSize)accessoryContainerSizeForType:(STKSettingsItemType)type {
    CGSize size = CGSizeZero;

    switch (type) {
        case STKSettingsItemTypeDisclosureIndicator:
            size = [UIImage imageNamed:@"Forward Icon"].size;
            break;

        case STKSettingsItemTypeSwitch:
            size = CGSizeMake(51.0f, 31.0f);
            break;
    }

    return size;
}

#pragma mark - Setup

- (void)setupWithSettingsItem:(STKSettingsItem *)item {
    self.type = item.type;
    self.imageNode.image = item.image;

    NSString *title = item.title ?: @"No title";
    self.titleTextNode.attributedString = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_settingsItemTitleAttributes]];

    self.accessorySwitchNode.on = item.value;
    self.userInteractionEnabled = item.enabled;
    self.alpha = item.enabled ? 1.0f : 0.5f;
}

- (void)setupContainerNode {
    self.containerNode = [[ASDisplayNode alloc] init];
    self.containerNode.backgroundColor = [UIColor whiteColor];

    [self addSubnode:self.containerNode];
}

- (void)setupImageNode {
    self.imageNode = [[ASImageNode alloc] init];
    self.imageNode.layerBacked = YES;
    self.imageNode.placeholderEnabled = YES;
    self.imageNode.contentMode = UIViewContentModeScaleAspectFit;

    [self.containerNode addSubnode:self.imageNode];
}

- (void)setupTitleTextNode {
    self.titleTextNode = [[ASTextNode alloc] init];
    self.titleTextNode.layerBacked = YES;
    self.titleTextNode.placeholderEnabled = YES;

    [self.containerNode addSubnode:self.titleTextNode];
}

- (void)setupAccessoryContainerNode {
    self.accessoryContainerNode = [[ASDisplayNode alloc] init];

    [self.containerNode addSubnode:self.accessoryContainerNode];
}

- (void)setupAccessoryImageNode {
    self.accessoryImageNode = [[ASImageNode alloc] init];
    self.accessoryImageNode.layerBacked = YES;
    self.accessoryImageNode.placeholderEnabled = YES;

    [self.accessoryContainerNode addSubnode:self.accessoryImageNode];
}

- (void)setupAccessorySwitchNode {
    self.accessorySwitchNode = [[STKSwitchNode alloc] init];
    [self.accessorySwitchNode addTarget:self action:@selector(accessorySwitchNodeValueChanged:)];
    self.accessorySwitchNode.placeholderEnabled = YES;

    [self.accessoryContainerNode addSubnode:self.accessorySwitchNode];
}

- (void)configureAccessoryContainerNodeWithType:(STKSettingsItemType)type {
    self.accessoryImageNode.hidden = YES;
    self.accessorySwitchNode.hidden = YES;

    switch (type) {
        case STKSettingsItemTypeDisclosureIndicator: {
            self.accessoryImageNode.hidden = NO;
            UIImage *image = [UIImage imageNamed:@"Forward Icon"];
            self.accessoryImageNode.image = image;
            self.accessoryImageNodeFrame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
        }
            break;

        case STKSettingsItemTypeSwitch:
            self.accessorySwitchNode.hidden = NO;
            self.accessorySwitchNodeFrame = CGRectMake(0.0f, 0.0f, 51.0f, 31.0f);
            break;
    }
}

#pragma mark - Actions

- (void)accessorySwitchNodeValueChanged:(STKSwitchNode *)switchNode {
    [self.delegate settingsItemNode:self didChangeValue:switchNode.on];
}

#pragma mark - Setters

- (void)setType:(STKSettingsItemType)type {
    _type = type;
    
    [self invalidateCalculatedLayout];
}

@end
