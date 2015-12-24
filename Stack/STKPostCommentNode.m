//
//  STKPostCommentNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostCommentNode.h"

#import "STKComment.h"
#import "STKPost.h"

#import "STKImageCache.h"
#import "STKImageDownloader.h"

#import "STKAttributes.h"
#import "ASImageNode+STKModificationBlocks.h"
#import "NSMutableAttributedString+STKHTML.h"
#import "ASDisplayNode+STKShadow.h"
#import "NSDate+STKTimeSince.h"
#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <RZUtils/UIImage+RZSolidColor.h>

@interface STKPostCommentNode () <ASTextNodeDelegate>

@property (strong, nonatomic) ASDisplayNode *containerNode;
@property (strong, nonatomic) ASNetworkImageNode *authorNetworkImageNode;
@property (strong, nonatomic) ASTextNode *authorTextNode;
@property (strong, nonatomic) ASTextNode *bodyTextNode;

@property (assign, nonatomic) CGRect containerNodeFrame;
@property (assign, nonatomic) CGRect authorNetworkImageNodeFrame;
@property (assign, nonatomic) CGRect authorTextNodeFrame;
@property (assign, nonatomic) CGRect bodyTextNodeFrame;

@end

@implementation STKPostCommentNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];

        [self setupContainerNode];
        [self setupAuthorNetworkImageNode];
        [self setupAuthorTextNode];
        [self setupBodyTextNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGFloat containerWidth = constrainedSize.width - 50.0f;

    CGSize authorNetworkImageSize = CGSizeMake(50.0f, 50.0f);

    CGSize authorTextConstrainedSize = CGSizeMake(containerWidth - authorNetworkImageSize.width - 12.5f, constrainedSize.height);
    CGSize authorTextSize = [self.authorTextNode measure:authorTextConstrainedSize];

    CGSize bodyTextConstrainedSize = CGSizeMake(containerWidth - authorNetworkImageSize.width - 12.5f, constrainedSize.height);
    CGSize bodyTextSize = [self.bodyTextNode measure:bodyTextConstrainedSize];

    CGFloat containerHeight = MAX(authorNetworkImageSize.height, authorTextSize.height + 12.5f + bodyTextSize.height);
    CGSize containerSize = CGSizeMake(containerWidth, containerHeight);

    //Positioning
    CGFloat x = 25.0f;
    CGFloat y = 12.5f;

    self.containerNodeFrame = CGRectMake(x, y, containerSize.width, containerSize.height);

    x = 0.0f;
    y = 0.0f;

    self.authorNetworkImageNodeFrame = CGRectMake(x, y, authorNetworkImageSize.width, authorNetworkImageSize.height);

    x = CGRectGetMaxX(self.authorNetworkImageNodeFrame) + 12.5f;
    y = 0.0f;

    self.authorTextNodeFrame = CGRectMake(x, y, authorTextSize.width, authorTextSize.height);

    x = CGRectGetMaxX(self.authorNetworkImageNodeFrame) + 12.5f;
    y = CGRectGetMaxY(self.authorTextNodeFrame) + 12.5f;

    self.bodyTextNodeFrame = CGRectMake(x, y, bodyTextSize.width, bodyTextSize.height);

    return CGSizeMake(constrainedSize.width, containerSize.height + 25.0f);
}

- (void)layout {
    self.containerNode.frame = self.containerNodeFrame;
    self.authorNetworkImageNode.frame = self.authorNetworkImageNodeFrame;
    self.authorTextNode.frame = self.authorTextNodeFrame;
    self.bodyTextNode.frame = self.bodyTextNodeFrame;
}

#pragma mark - Setup

- (void)setupContainerNode {
    self.containerNode = [[ASDisplayNode alloc] init];
    self.containerNode.backgroundColor = [UIColor whiteColor];

    [self addSubnode:self.containerNode];
}

- (void)setupAuthorNetworkImageNode {
    self.authorNetworkImageNode = [[ASNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    self.authorNetworkImageNode.layerBacked = YES;
    self.authorNetworkImageNode.contentMode = UIViewContentModeScaleAspectFill;
    self.authorNetworkImageNode.imageModificationBlock = STKImageNodeCornerRadiusModificationBlock(50.0f);
    self.authorNetworkImageNode.placeholderEnabled = YES;

    [self.containerNode addSubnode:self.authorNetworkImageNode];
}

- (void)setupAuthorTextNode {
    self.authorTextNode = [[ASTextNode alloc] init];
    self.authorTextNode.layerBacked = YES;
    self.authorTextNode.placeholderEnabled = YES;

    [self.containerNode addSubnode:self.authorTextNode];
}

- (void)setupBodyTextNode {
    self.bodyTextNode = [[ASTextNode alloc] init];
    self.bodyTextNode.delegate = self;
    self.bodyTextNode.userInteractionEnabled = YES;
    self.bodyTextNode.linkAttributeNames = @[@"STKLink"];
    self.bodyTextNode.placeholderEnabled = YES;

    [self.containerNode addSubnode:self.bodyTextNode];
}

- (void)setupWithComment:(STKComment *)comment {
    UIColor *color = [STKSource colorForType:comment.post.sourceType.integerValue];
    UIImage *image = [UIImage rz_solidColorImageWithSize:CGSizeMake(50.0f, 50.0f) color:color];
    self.authorNetworkImageNode.defaultImage = image;

    NSURL *URL = comment.authorAvatarImageURL ? [NSURL URLWithString:comment.authorAvatarImageURL] : nil;
    self.authorNetworkImageNode.URL = URL;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];

    NSString *author = comment.authorName ?: @"No name";
    NSAttributedString *authorAttributedString = [[NSAttributedString alloc] initWithString:author attributes:[STKAttributes stk_commentNodeAuthorAttributes]];
    [attributedString appendAttributedString:authorAttributedString];

    [[attributedString mutableString] appendString:@"  "];

    NSString *date = [comment.createDate stk_timeSinceNow] ?: @"No timestamp";
    NSAttributedString *dateAttributedString = [[NSAttributedString alloc] initWithString:date attributes:[STKAttributes stk_commentNodeDateAttributes]];
    [attributedString appendAttributedString:dateAttributedString];
    self.authorTextNode.attributedString = attributedString;

    NSMutableAttributedString *bodyAttributedString = [comment.attributedContent mutableCopy];
    if (bodyAttributedString) {
        UIColor *linkColor = [STKSource colorForType:comment.post.sourceType.integerValue];
        [bodyAttributedString stk_setLineSpacing:6.0f];
        [bodyAttributedString stk_setLinkColor:linkColor underlineStyle:NSUnderlineStyleSingle];
    }

    self.bodyTextNode.attributedString = bodyAttributedString;
}

#pragma mark - ASText Node Delegate

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange {
    if ([attribute isEqualToString:@"STKLink"] && [value isKindOfClass:[NSString class]]) {
        NSURL *URL = [NSURL URLWithString:value];

        if ([self.delegate respondsToSelector:@selector(postCommentNode:didTapLink:)]) {
            [self.delegate postCommentNode:self didTapLink:URL];
        }
    }
}

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
    return [attribute isEqualToString:@"STKLink"];
}

@end
