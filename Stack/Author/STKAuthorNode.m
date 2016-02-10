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

#import "STKNetworkImageNode.h"
#import "STKAttributes.h"
#import "ASImageNode+STKModificationBlocks.h"
#import "UIColor+STKStyle.h"
#import "NSMutableAttributedString+STKHTML.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <RZUtils/UIImage+RZSolidColor.h>

@interface STKAuthorNode () <ASTextNodeDelegate>

@property (strong, nonatomic) ASImageNode *sourceBannerImageNode;
@property (strong, nonatomic) ASImageNode *authorBorderImageNode;
@property (strong, nonatomic) STKNetworkImageNode *authorNetworkImageNode;
@property (strong, nonatomic) ASTextNode *authorTextNode;
@property (strong, nonatomic) ASTextNode *summaryTextNode;

@property (assign, nonatomic) CGRect sourceBannerImageNodeFrame;
@property (assign, nonatomic) CGRect authorBorderImageNodeFrame;
@property (assign, nonatomic) CGRect authorNetworkImageNodeFrame;
@property (assign, nonatomic) CGRect authorTextNodeFrame;
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
        [self setupAuthorTextNode];
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

    self.authorNetworkImageNode.staticImageSize = CGSizeMake(100.0f, 100.0f);
    CGSize authorNetworkImageSize = [self.authorNetworkImageNode measure:constrainedSize];

    UIFont *font = [STKAttributes stk_authorNameAttributes][NSFontAttributeName];
    CGFloat authorAvailableWidth = constrainedSize.width - ((3 * 12.5f) + authorBorderSize.width);
    CGSize authorConstrainedSize = CGSizeMake(authorAvailableWidth, font.lineHeight);
    CGSize authorSize = [self.authorTextNode measure:authorConstrainedSize];

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

//    CGFloat authorOffset = CGRectGetMaxX(self.authorBorderImageNodeFrame) + 12.5f;
//    x = authorOffset + (authorAvailableWidth / 2) - (authorSize.width / 2);
    x = CGRectGetMaxX(self.authorBorderImageNodeFrame) + 12.5f;
    y = CGRectGetMidY(self.authorBorderImageNodeFrame) + (((CGRectGetHeight(self.authorBorderImageNodeFrame) / 2) + 12.5f) / 2) - (authorSize.height / 2);

    self.authorTextNodeFrame = CGRectMake(x, y, authorSize.width, authorSize.height);

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
    self.authorTextNode.frame = self.authorTextNodeFrame;
    self.summaryTextNode.frame = self.summaryTextNodeFrame;
}

#pragma mark - Setup

- (void)setupWithAuthor:(STKAuthor *)author {
    self.authorNetworkImageNode.stk_placeholderColor = [STKSource colorForType:author.sourceType.integerValue];

    NSString *imageName = [STKSource bannerImageNameForType:author.sourceType.integerValue];
    UIImage *image = [UIImage imageNamed:imageName];
    self.bannerImageSize = image.size;
    self.sourceBannerImageNode.image = image;

    NSURL *URL = author.avatarImageURL ? [NSURL URLWithString:author.avatarImageURL] : nil;
    if (URL) {
        self.authorNetworkImageNode.URL = URL;
    }

    NSString *authorName = author.name ?: @"No name";
    authorName = [authorName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAttributedString *attributedName = [[NSAttributedString alloc] initWithString:authorName attributes:[STKAttributes stk_authorNameAttributes]];

    self.authorTextNode.attributedString = attributedName;

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
    self.authorNetworkImageNode = [[STKNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    self.authorNetworkImageNode.layerBacked = YES;
    self.authorNetworkImageNode.contentMode = UIViewContentModeScaleAspectFit;
    self.authorNetworkImageNode.imageModificationBlock = STKImageNodeCornerRadiusModificationBlock(100.0f);

    [self addSubnode:self.authorNetworkImageNode];
}

- (void)setupAuthorTextNode {
    self.authorTextNode = [[ASTextNode alloc] init];
    self.authorTextNode.placeholderEnabled = YES;

    [self addSubnode:self.authorTextNode];
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

@end
