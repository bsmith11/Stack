//
//  STKAuthorNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKAuthorNode.h"

#import "STKAuthor.h"

#import "STKImageCache.h"
#import "STKImageDownloader.h"

#import "STKAttributes.h"
#import "ASImageNode+STKModificationBlocks.h"
#import "UIColor+STKStyle.h"
#import "NSMutableAttributedString+STKHTML.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <RZUtils/UIImage+RZSolidColor.h>
#import <pop/POP.h>

@interface STKAuthorNode () <ASTextNodeDelegate, ASNetworkImageNodeDelegate>

@property (strong, nonatomic) ASImageNode *sourceBannerImageNode;
@property (strong, nonatomic) ASImageNode *authorBorderImageNode;
@property (strong, nonatomic) ASNetworkImageNode *authorNetworkImageNode;
@property (strong, nonatomic) ASTextNode *summaryTextNode;

@property (assign, nonatomic) CGRect sourceBannerImageNodeFrame;
@property (assign, nonatomic) CGRect authorBorderImageNodeFrame;
@property (assign, nonatomic) CGRect authorNetworkImageNodeFrame;
@property (assign, nonatomic) CGRect summaryTextNodeFrame;

@property (assign, nonatomic) CGSize bannerImageSize;

@end

@implementation STKAuthorNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];

        [self setupSourceBannerImageNode];
        [self setupAuthorBorderImageNode];
        [self setupAuthorNetworkImageNode];
        [self setupSummaryTextNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGFloat ratio = (self.bannerImageSize.width / constrainedSize.width) ?: 1.0f;
    CGFloat height = self.bannerImageSize.height / ratio;
    CGSize sourceBannerImageSize = CGSizeMake(constrainedSize.width, height);

    CGSize authorBorderSize = CGSizeMake(112.5f, 112.5f);

    CGSize authorNetworkImageSize = CGSizeMake(100.0f, 100.0f);

    CGSize summarySize = CGSizeZero;
    if (self.summaryTextNode.attributedString) {
        CGSize summaryConstrainedSize = CGSizeMake(constrainedSize.width - 25.0f, constrainedSize.height - sourceBannerImageSize.height - (authorNetworkImageSize.height / 2) - 25.0f);
        summarySize = [self.summaryTextNode measure:summaryConstrainedSize];
    }

    //Positioning
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;

    self.sourceBannerImageNodeFrame = CGRectMake(x, y, sourceBannerImageSize.width, sourceBannerImageSize.height);

    x = 12.5f;
    y = CGRectGetMaxY(self.sourceBannerImageNodeFrame) - (authorBorderSize.height / 2);

    self.authorBorderImageNodeFrame = CGRectMake(x, y, authorBorderSize.width, authorBorderSize.height);

    x = CGRectGetMidX(self.authorBorderImageNodeFrame) - (authorNetworkImageSize.width / 2);
    y = CGRectGetMaxY(self.sourceBannerImageNodeFrame) - (authorNetworkImageSize.height / 2);

    self.authorNetworkImageNodeFrame = CGRectMake(x, y, authorNetworkImageSize.width, authorNetworkImageSize.height);

    x = 12.5f;
    CGFloat offset = (summarySize.height > 0) ? 12.5f : 0.0f;
    y = CGRectGetMaxY(self.authorNetworkImageNodeFrame) + offset;

    self.summaryTextNodeFrame = CGRectMake(x, y, summarySize.width, summarySize.height);

    return CGSizeMake(constrainedSize.width, CGRectGetMaxY(self.summaryTextNodeFrame) + 12.5f);
}

- (void)layout {
    self.sourceBannerImageNode.frame = self.sourceBannerImageNodeFrame;
    self.authorBorderImageNode.frame = self.authorBorderImageNodeFrame;
    self.authorNetworkImageNode.frame = self.authorNetworkImageNodeFrame;
    self.summaryTextNode.frame = self.summaryTextNodeFrame;
}

#pragma mark - Setup

- (void)setupWithAuthor:(STKAuthor *)author {
    NSString *imageName = [STKSource bannerImageNameForType:author.sourceType.integerValue];
    UIImage *image = [UIImage imageNamed:imageName];
    self.bannerImageSize = image.size;
    self.sourceBannerImageNode.image = image;

    NSURL *URL = author.avatarImageURL ? [NSURL URLWithString:author.avatarImageURL] : nil;
    if (URL) {
        self.authorNetworkImageNode.URL = URL;
    }

    NSMutableAttributedString *attributedString = [author.attributedSummary mutableCopy];
    if (attributedString) {
        UIColor *linkColor = [STKSource colorForType:author.sourceType.integerValue];
        [attributedString stk_setLineSpacing:6.0f];
        [attributedString stk_setLinkColor:linkColor underlineStyle:NSUnderlineStyleSingle];
    }

    self.summaryTextNode.attributedString = attributedString;
}

- (void)setupSourceBannerImageNode {
    self.sourceBannerImageNode = [[ASImageNode alloc] init];
    self.sourceBannerImageNode.layerBacked = YES;
    self.sourceBannerImageNode.contentMode = UIViewContentModeScaleAspectFit;
    self.sourceBannerImageNode.placeholderEnabled = YES;

    [self addSubnode:self.sourceBannerImageNode];
}

- (void)setupAuthorBorderImageNode {
    self.authorBorderImageNode = [[ASImageNode alloc] init];
    self.authorBorderImageNode.layerBacked = YES;
    self.authorBorderImageNode.image = [UIImage rz_solidColorImageWithSize:CGSizeMake(112.5f, 112.5f) color:[UIColor whiteColor]];
    self.authorBorderImageNode.imageModificationBlock = STKImageNodeCornerRadiusModificationBlock(112.5f);

    [self addSubnode:self.authorBorderImageNode];
}

- (void)setupAuthorNetworkImageNode {
    self.authorNetworkImageNode = [[ASNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    self.authorNetworkImageNode.layerBacked = YES;
    self.authorNetworkImageNode.contentMode = UIViewContentModeScaleAspectFit;
    self.authorNetworkImageNode.imageModificationBlock = STKImageNodeCornerRadiusModificationBlock(100.0f);
    self.authorNetworkImageNode.defaultImage = [UIImage rz_solidColorImageWithSize:CGSizeMake(2 * 50.0f, 2 * 50.0f) color:[UIColor stk_stackColor]];
    self.authorNetworkImageNode.placeholderEnabled = YES;
    self.authorNetworkImageNode.delegate = self;

    [self addSubnode:self.authorNetworkImageNode];
}

- (void)setupSummaryTextNode {
    self.summaryTextNode = [[ASTextNode alloc] init];
    self.summaryTextNode.placeholderEnabled = YES;
    self.summaryTextNode.delegate = self;
    self.summaryTextNode.userInteractionEnabled = YES;
    self.summaryTextNode.linkAttributeNames = @[@"STKLink"];

    [self addSubnode:self.summaryTextNode];
}

#pragma mark - ASText Node Delegate

- (void)textNode:(ASTextNode *)textNode tappedLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point textRange:(NSRange)textRange {
    if ([attribute isEqualToString:@"STKLink"] && [value isKindOfClass:[NSString class]]) {
        NSURL *URL = [NSURL URLWithString:value];

        if ([self.delegate respondsToSelector:@selector(authorNode:didTapLink:)]) {
            [self.delegate authorNode:self didTapLink:URL];
        }
    }
}

- (BOOL)textNode:(ASTextNode *)textNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
    return [attribute isEqualToString:@"STKLink"];
}

#pragma mark - Network Image Node Delegate

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    imageNode.alpha = 0.0f;
}

- (void)imageNodeDidFinishDecoding:(ASNetworkImageNode *)imageNode {
    POPBasicAnimation *animation = [imageNode pop_animationForKey:@"fade_animation"];
    if (!animation) {
        animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    }

    animation.fromValue = @(imageNode.alpha);
    animation.toValue = @1.0f;
    animation.duration = 1.0;
    
    [imageNode pop_addAnimation:animation forKey:@"fade_animation"];
}

@end
