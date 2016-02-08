//
//  STKEventBracketsListCell.m
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracketsListCell.h"

#import "STKEventBracket.h"

#import "STKAttributes.h"
#import "UIColor+STKStyle.h"
#import "UIFont+STKStyle.h"

@interface STKEventBracketsListCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *accessoryImageView;

@end

@implementation STKEventBracketsListCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self setupTitleLabel];
        [self setupAccessoryImageView];
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

- (void)setupWithBracket:(STKEventBracket *)bracket {
    NSString *name = bracket.name ?: @"No name";
    NSDictionary *attributes = [STKAttributes stk_settingsHeaderTitleAttributes];

    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:name attributes:attributes];
}

@end
