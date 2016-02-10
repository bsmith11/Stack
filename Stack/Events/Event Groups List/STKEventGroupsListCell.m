//
//  STKEventGroupsListCell.m
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventGroupsListCell.h"

#import "STKEventGroup.h"

#import "STKAttributes.h"
#import "UIColor+STKStyle.h"

@interface STKEventGroupsListCell ()

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *accessoryImageView;

@end

@implementation STKEventGroupsListCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor stk_backgroundColor];

        [self setupContainerView];
        [self setupTitleLabel];
        [self setupAccessoryImageView];
    }

    return self;
}

#pragma mark - Setup

- (void)setupContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.containerView];

    self.containerView.backgroundColor = [UIColor whiteColor];

    [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:1.0f].active = YES;
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.titleLabel];

    self.titleLabel.numberOfLines = 1;

    [self.titleLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:12.5f].active = YES;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:12.5f].active = YES;
    [self.containerView.bottomAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12.5f].active = YES;
}

- (void)setupAccessoryImageView {
    self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.accessoryImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.accessoryImageView];

    self.accessoryImageView.image = [[UIImage imageNamed:@"disclosureArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.accessoryImageView.tintColor = [UIColor stk_stackColor];
    [self.accessoryImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.accessoryImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.accessoryImageView.centerYAnchor constraintEqualToAnchor:self.containerView.centerYAnchor].active = YES;
    [self.accessoryImageView.leadingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:12.5f].active = YES;
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.accessoryImageView.trailingAnchor constant:12.5f].active = YES;
}

- (void)setupWithGroup:(STKEventGroup *)group {
    NSString *name = group.name ?: @"No name";
    NSDictionary *attributes = [STKAttributes stk_postNodeTitleAttributes];

    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:name attributes:attributes];
}

@end
