//
//  STKEventBracketHeader.m
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracketHeader.h"

#import "STKEventStage.h"

#import "STKAttributes.h"
#import "UIFont+STKStyle.h"
#import "UIColor+STKStyle.h"

@interface STKEventBracketHeader ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation STKEventBracketHeader

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor stk_backgroundColor];

        [self setupTitleLabel];
    }

    return self;
}

#pragma mark - Setup

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.titleLabel];

    self.titleLabel.numberOfLines = 1;

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:12.5f].active = YES;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12.5f].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:0.0f].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:12.5f].active = YES;
}

- (void)setupWithStage:(STKEventStage *)stage {
    NSString *name = stage.name ?: @"No name";
    NSMutableDictionary *attributes = [[STKAttributes stk_settingsHeaderTitleAttributes] mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;

    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:name attributes:attributes];
}

#pragma mark - Height

+ (CGFloat)height {
    CGFloat titleHeight = [UIFont stk_settingsHeaderTitleFont].lineHeight;
    CGFloat height = 12.5f + titleHeight;
    
    return height;
}

@end
