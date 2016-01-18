//
//  STKPostNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostNode.h"

#import "STKPost.h"
#import "STKPostSearchResult.h"

#import "STKImageCache.h"
#import "STKImageDownloader.h"

#import "STKNetworkImageNode.h"
#import "ASImageNode+STKModificationBlocks.h"
#import "STKAttributes.h"
#import "NSDate+STKTimeSince.h"
#import "ASDisplayNode+STKShadow.h"
#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <tgmath.h>

@interface STKPostNode ()

@property (strong, nonatomic) ASDisplayNode *containerNode;
@property (strong, nonatomic) STKNetworkImageNode *featureNetworkImageNode;
@property (strong, nonatomic) ASDisplayNode *infoContainerNode;
@property (strong, nonatomic) ASDisplayNode *textContainerNode;
@property (strong, nonatomic) ASTextNode *titleTextNode;
@property (strong, nonatomic) ASTextNode *dateTextNode;
@property (strong, nonatomic) ASImageNode *sourceImageNode;

@property (assign, nonatomic) CGRect containerNodeFrame;
@property (assign, nonatomic) CGRect featureNetworkImageNodeFrame;
@property (assign, nonatomic) CGRect infoContainerNodeFrame;
@property (assign, nonatomic) CGRect textContainerNodeFrame;
@property (assign, nonatomic) CGRect titleTextNodeFrame;
@property (assign, nonatomic) CGRect dateTextNodeFrame;
@property (assign, nonatomic) CGRect sourceImageNodeFrame;

@property (assign, nonatomic, readonly) BOOL hasFeatureImage;

@end

@implementation STKPostNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = NO;

        [self setupContainerNode];
        [self setupFeatureNetworkImageNode];
        [self setupInfoContainerNode];
        [self setupTextContainerNode];
        [self setupTitleTextNode];
        [self setupDateTextNode];
        [self setupSourceImageNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGFloat containerWidth = constrainedSize.width;

    CGFloat featureImageHeight = self.hasFeatureImage ? 150.0f : 0.0f;
    self.featureNetworkImageNode.staticImageSize = CGSizeMake(containerWidth, featureImageHeight);
    CGSize featureImageSize = [self.featureNetworkImageNode measure:constrainedSize];

    CGFloat infoContainerWidth = containerWidth - 25.0f;

    CGSize sourceImageSize = CGSizeMake(35.0f, 35.0f);

    CGFloat textContainerWidth = infoContainerWidth - 12.5f - sourceImageSize.width;

    CGSize titleConstrainedSize = CGSizeMake(textContainerWidth, constrainedSize.height);
    CGSize titleSize = [self.titleTextNode measure:titleConstrainedSize];
    titleSize.height = __tg_ceil(titleSize.height);

    CGSize dateConstrainedSize = CGSizeMake(textContainerWidth, constrainedSize.height);
    CGSize dateSize = [self.dateTextNode measure:dateConstrainedSize];
    dateSize.height = __tg_ceil(dateSize.height);

    UIFont *titleFont = [STKAttributes stk_postNodeTitleAttributes][NSFontAttributeName];
    UIFont *dateFont = [STKAttributes stk_postNodeDateAttributes][NSFontAttributeName];
    CGFloat spacing = __tg_ceil(sourceImageSize.height - titleFont.lineHeight  - dateFont.lineHeight);

    CGSize textContainerSize = CGSizeMake(textContainerWidth, titleSize.height + spacing + dateSize.height);

    CGSize infoContainerSize = CGSizeMake(infoContainerWidth, MAX(textContainerSize.height, sourceImageSize.height));

    CGSize containerSize = CGSizeMake(containerWidth, 12.5f + featureImageSize.height + 12.5f + infoContainerSize.height);

    //Positioning
    CGFloat x = 0.0f;
    CGFloat y = 6.25f;

    self.containerNodeFrame = CGRectMake(x, y, containerSize.width, containerSize.height);

    x = 12.5f;
    y = 12.5f;

    self.infoContainerNodeFrame = CGRectMake(x, y, infoContainerSize.width, infoContainerSize.height);

    x = 0.0f;
    y = CGRectGetMaxY(self.infoContainerNodeFrame);
    y += (self.hasFeatureImage) ? 12.5f : 0.0f;

    self.featureNetworkImageNodeFrame = CGRectMake(x, y, featureImageSize.width, featureImageSize.height);

    x = sourceImageSize.width + 12.5f;
    y = 0.0f;

    self.textContainerNodeFrame = CGRectMake(x, y, textContainerSize.width, textContainerSize.height);

    x = 0.0f;
    y = 0.0f;

    self.titleTextNodeFrame = CGRectMake(x, y, titleSize.width, titleSize.height);

    x = 0.0f;
    y = CGRectGetMaxY(self.titleTextNodeFrame) + spacing;

    self.dateTextNodeFrame = CGRectMake(x, y, dateSize.width, dateSize.height);

    x = 0.0f;
    y = 0.0f;

    self.sourceImageNodeFrame = CGRectMake(x, y, sourceImageSize.width, sourceImageSize.height);

    return CGSizeMake(containerSize.width, containerSize.height + 12.5f);
}

- (void)layout {
    self.containerNode.frame = self.containerNodeFrame;
    self.featureNetworkImageNode.frame = self.featureNetworkImageNodeFrame;
    self.infoContainerNode.frame = self.infoContainerNodeFrame;
    self.textContainerNode.frame = self.textContainerNodeFrame;
    self.titleTextNode.frame = self.titleTextNodeFrame;
    self.dateTextNode.frame = self.dateTextNodeFrame;
    self.sourceImageNode.frame = self.sourceImageNodeFrame;
}

#pragma mark - Setup

- (void)setupWithPost:(STKPost *)post {
    self.featureNetworkImageNode.URL = post.featureImageURL;

    NSString *title = post.title ?: @"No title";
    self.titleTextNode.attributedString = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_postNodeTitleAttributes]];

    NSString *date = [post.createDate stk_timeSinceNow] ?: @"No timestamp";
    self.dateTextNode.attributedString = [[NSAttributedString alloc] initWithString:date attributes:[STKAttributes stk_postNodeDateAttributes]];

    UIImage *image = [UIImage imageNamed:[STKSource imageNameForType:post.sourceType.integerValue]];
    self.sourceImageNode.image = image;
}

- (void)setupWithPostSearchResult:(STKPostSearchResult *)postSearchResult {
    self.featureNetworkImageNode.URL = nil;

    NSString *title = postSearchResult.title ?: @"No title";
    self.titleTextNode.attributedString = [[NSAttributedString alloc] initWithString:title attributes:[STKAttributes stk_postNodeTitleAttributes]];

    NSString *date = [postSearchResult.createDate stk_timeSinceNow] ?: @"No timestamp";
    self.dateTextNode.attributedString = [[NSAttributedString alloc] initWithString:date attributes:[STKAttributes stk_postNodeDateAttributes]];

    UIImage *image = [UIImage imageNamed:[STKSource imageNameForType:postSearchResult.sourceType.integerValue]];
    self.sourceImageNode.image = image;
}

- (void)setupContainerNode {
    self.containerNode = [[ASDisplayNode alloc] init];
    self.containerNode.layerBacked = YES;
    self.containerNode.backgroundColor = [UIColor whiteColor];

    [self addSubnode:self.containerNode];
}

- (void)setupFeatureNetworkImageNode {
    self.featureNetworkImageNode = [[STKNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    self.featureNetworkImageNode.layerBacked = YES;
    self.featureNetworkImageNode.contentMode = UIViewContentModeScaleAspectFill;
    self.featureNetworkImageNode.backgroundColor = [UIColor whiteColor];

    [self.containerNode addSubnode:self.featureNetworkImageNode];
}

- (void)setupInfoContainerNode {
    self.infoContainerNode = [[ASDisplayNode alloc] init];
    self.infoContainerNode.layerBacked = YES;
    self.infoContainerNode.shouldRasterizeDescendants = YES;
    self.infoContainerNode.backgroundColor = [UIColor whiteColor];

    [self.containerNode addSubnode:self.infoContainerNode];
}

- (void)setupTextContainerNode {
    self.textContainerNode = [[ASDisplayNode alloc] init];
    self.textContainerNode.layerBacked = YES;

    [self.infoContainerNode addSubnode:self.textContainerNode];
}

- (void)setupTitleTextNode {
    self.titleTextNode = [[ASTextNode alloc] init];
    self.titleTextNode.layerBacked = YES;
    self.titleTextNode.placeholderEnabled = YES;

    [self.textContainerNode addSubnode:self.titleTextNode];
}

- (void)setupDateTextNode {
    self.dateTextNode = [[ASTextNode alloc] init];
    self.dateTextNode.layerBacked = YES;
    self.dateTextNode.placeholderEnabled = YES;

    [self.textContainerNode addSubnode:self.dateTextNode];
}

- (void)setupSourceImageNode {
    self.sourceImageNode = [[ASImageNode alloc] init];
    self.sourceImageNode.contentMode = UIViewContentModeScaleAspectFill;
    self.sourceImageNode.layerBacked = YES;
    self.sourceImageNode.placeholderEnabled = YES;

    [self.infoContainerNode addSubnode:self.sourceImageNode];
}

#pragma mark - Getters

- (BOOL)hasFeatureImage {
    return (self.featureNetworkImageNode.URL != nil);
}

@end
