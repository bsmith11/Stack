//
//  STKEventPoolHeader.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPoolHeader.h"

#import "STKEventPool.h"

#import "STKAttributes.h"
#import "UIFont+STKStyle.h"
#import "UIColor+STKStyle.h"

@interface STKEventPoolHeader ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *accessoryImageView;

@property (assign, nonatomic) NSInteger section;

@end

@implementation STKEventPoolHeader

#pragma mark - Lifecycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        self.contentView.backgroundColor = [UIColor stk_backgroundColor];

        [self setupTitleLabel];
        [self setupAccessoryImageView];

        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        [self.contentView addGestureRecognizer:gesture];
    }

    return self;
}

#pragma mark - Setup

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];

    self.titleLabel.numberOfLines = 1;

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12.5f].active = YES;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12.5f].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12.5f].active = YES;
}

- (void)setupAccessoryImageView {
    self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.accessoryImageView];

    self.accessoryImageView.image = [[UIImage imageNamed:@"disclosureArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.accessoryImageView.tintColor = [UIColor stk_stackColor];
    [self.accessoryImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.accessoryImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.accessoryImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.accessoryImageView.leadingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:12.5f].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.accessoryImageView.trailingAnchor constant:12.5f].active = YES;
}

- (void)setupWithPool:(STKEventPool *)pool section:(NSInteger)section {
    NSString *name = pool.name ?: @"No name";
    NSDictionary *attributes = [STKAttributes stk_settingsHeaderTitleAttributes];

    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:name attributes:attributes];

    self.section = section;
}

#pragma mark - Actions

- (void)didTap {
    if ([self.delegate respondsToSelector:@selector(didSelectHeaderInSection:)]) {
        [self.delegate didSelectHeaderInSection:self.section];
    }
}

#pragma mark - Height

+ (CGFloat)height {
    CGFloat titleHeight = [UIFont stk_settingsHeaderTitleFont].lineHeight;
    CGFloat height = 12.5f + titleHeight + 12.5f;
    
    return height;
}

@end
