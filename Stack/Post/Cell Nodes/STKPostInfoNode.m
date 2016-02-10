//
//  STKPostInfoNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKPostInfoNode.h"

#import "STKPost.h"
#import "STKAuthor.h"

#import "STKAttributes.h"
#import "NSDate+STKTimeSince.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKPostInfoNode ()

@property (strong, nonatomic) ASTextNode *authorTextNode;
@property (strong, nonatomic) ASTextNode *dateTextNode;

@property (assign, nonatomic) CGRect authorTextNodeFrame;
@property (assign, nonatomic) CGRect dateTextNodeFrame;

@end

@implementation STKPostInfoNode

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupAuthorTextNode];
        [self setupDateTextNode];
    }

    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    //Sizing
    CGSize authorNameConstrainedSize = CGSizeMake(constrainedSize.width - 50.0f, constrainedSize.height);
    CGSize authorNameSize = [self.authorTextNode measure:authorNameConstrainedSize];

    CGSize dateConstrainedSize = CGSizeMake(constrainedSize.width - authorNameSize.width - 50.0f - 15.0f, constrainedSize.height);
    CGSize dateSize = [self.dateTextNode measure:dateConstrainedSize];

    //Positioning
    CGFloat x = 25.0f;
    CGFloat y = 12.5f;

    if (self.authorTextNode.attributedString.length > 0) {
        self.authorTextNodeFrame = CGRectMake(x, y, authorNameSize.width, authorNameSize.height);

        x = CGRectGetMaxX(self.authorTextNodeFrame) + 12.5f;
        y = CGRectGetMidY(self.authorTextNodeFrame) - (dateSize.height / 2);
    }
    else {
        self.authorTextNodeFrame = CGRectZero;
    }

    self.dateTextNodeFrame = CGRectMake(x, y, dateSize.width, dateSize.height);

    CGFloat height = MAX(CGRectGetHeight(self.authorTextNodeFrame), CGRectGetHeight(self.dateTextNodeFrame));
    return CGSizeMake(constrainedSize.width, height + 25.0f);
}

- (void)layout {
    self.authorTextNode.frame = self.authorTextNodeFrame;
    self.dateTextNode.frame = self.dateTextNodeFrame;
}

#pragma mark - Setup

- (void)setupWithPost:(STKPost *)post {
    NSString *name = [post.author.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableDictionary *authorAttributes = [[STKAttributes stk_postAuthorAttributes] mutableCopy];
    authorAttributes[NSForegroundColorAttributeName] = [STKSource colorForType:post.sourceType.integerValue];

    if (name.length > 0) {
        self.authorTextNode.attributedString = [[NSAttributedString alloc] initWithString:name attributes:authorAttributes];
    }
    else {
        self.authorTextNode.attributedString = nil;
    }

    NSString *date = [post.createDate stk_timeSinceNow] ?: @"No timestamp";
    self.dateTextNode.attributedString = [[NSAttributedString alloc] initWithString:date attributes:[STKAttributes stk_postDateAttributes]];
}

- (void)setupAuthorTextNode {
    self.authorTextNode = [[ASTextNode alloc] init];
    self.authorTextNode.placeholderEnabled = YES;
    [self.authorTextNode addTarget:self action:@selector(didTapAuthorTextNode) forControlEvents:ASControlNodeEventTouchUpInside];

    [self addSubnode:self.authorTextNode];
}

- (void)setupDateTextNode {
    self.dateTextNode = [[ASTextNode alloc] init];
    self.dateTextNode.layerBacked = YES;
    self.dateTextNode.placeholderEnabled = YES;

    [self addSubnode:self.dateTextNode];
}

#pragma mark - Actions

- (void)didTapAuthorTextNode {
    if ([self.delegate respondsToSelector:@selector(postInfoNodeDidSelectAuthor:)]) {
        [self.delegate postInfoNodeDidSelectAuthor:self];
    }
}

@end
