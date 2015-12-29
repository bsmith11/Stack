//
//  STKSettingsHeaderNode.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSettingsHeaderNode.h"

#import "STKSettingsHeader.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKSettingsHeaderNode () <ASTextNodeDelegate>

@property (strong, nonatomic) ASTextNode *titleTextNode;

@property (assign, nonatomic) CGRect titleTextNodeFrame;

@end

@implementation STKSettingsHeaderNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupTitleTextNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGSize titleConstrainedSize = CGSizeMake(constrainedSize.width - (2 * 12.5f), constrainedSize.height);
    CGSize titleSize = [self.titleTextNode measure:titleConstrainedSize];

    //Positioning
    CGFloat x = 12.5f;
    CGFloat y = (2 * 12.5f);

    self.titleTextNodeFrame = CGRectMake(x, y, titleSize.width, titleSize.height);

    return CGSizeMake(constrainedSize.width, titleSize.height + (3 * 12.5f));
}

- (void)layout {
    self.titleTextNode.frame = self.titleTextNodeFrame;
}

#pragma mark - Setup

- (void)setupWithSettingsHeader:(STKSettingsHeader *)header delegate:(id<STKSettingsHeaderNodeDelegate>)delegate {
    self.titleTextNode.attributedString = header.title;
    self.delegate = delegate;
}

- (void)setupTitleTextNode {
    self.titleTextNode = [[ASTextNode alloc] init];
    self.titleTextNode.userInteractionEnabled = YES;
    self.titleTextNode.placeholderEnabled = YES;
    self.titleTextNode.delegate = self;
    self.titleTextNode.linkAttributeNames = @[@"STKLink"];

    [self addSubnode:self.titleTextNode];
}

#pragma mark - Text Node Delegate

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange {
    if ([value isKindOfClass:[NSString class]]) {
        NSURL *URL = [NSURL URLWithString:value];
        [self.delegate settingsHeaderNode:self didTapLink:URL];
    }
}

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
    return [attribute isEqualToString:@"STKLink"];
}

@end
