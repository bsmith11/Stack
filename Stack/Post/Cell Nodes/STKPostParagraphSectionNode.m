//
//  STKPostParagraphSectionNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostParagraphSectionNode.h"

#import "STKPostParagraphSection.h"
#import "STKPost.h"

#import "NSMutableAttributedString+STKHTML.h"
#import "STKAttributes.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKPostParagraphSectionNode () <ASTextNodeDelegate>

@property (strong, nonatomic) ASTextNode *textNode;

@end

@implementation STKPostParagraphSectionNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setupTextNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize sectionTextConstrainedSize = CGSizeMake(constrainedSize.width - 50.0f, constrainedSize.height);
    CGSize sectionTextSize = [self.textNode measure:sectionTextConstrainedSize];

    return CGSizeMake(constrainedSize.width, sectionTextSize.height + 25.0f);
}

- (void)layout {
    CGFloat x = 25.0f;
    CGFloat y = 12.5f;
    CGFloat width = self.textNode.calculatedSize.width;
    CGFloat height = self.textNode.calculatedSize.height;

    self.textNode.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Setup

- (void)setupWithSection:(STKPostParagraphSection *)section {
    NSMutableAttributedString *attributedString = [section.attributedContent mutableCopy];
    UIColor *linkColor = [STKSource colorForType:section.post.sourceType.integerValue];
    [attributedString stk_setLinkColor:linkColor underlineStyle:NSUnderlineStyleSingle];

    self.textNode.attributedString = attributedString;
}

- (void)setupTextNode {
    self.textNode = [[ASTextNode alloc] init];
    self.textNode.delegate = self;
    self.textNode.userInteractionEnabled = YES;
    self.textNode.placeholderEnabled = YES;
    self.textNode.linkAttributeNames = @[@"STKLink"];

    [self addSubnode:self.textNode];
}

#pragma mark - ASText Node Delegate

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange {
    if ([attribute isEqualToString:@"STKLink"] && [value isKindOfClass:[NSString class]]) {
        NSURL *URL = [NSURL URLWithString:value];

        if ([self.delegate respondsToSelector:@selector(postSectionNode:didTapLink:)]) {
            [self.delegate postSectionNode:self didTapLink:URL];
        }
    }
}

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
    return [attribute isEqualToString:@"STKLink"];
}

@end
