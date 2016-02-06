//
//  STKEventPoolCell.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPoolCell.h"

#import "STKEventStanding.h"

#import "STKAttributes.h"
#import "UIColor+STKStyle.h"

@interface STKEventPoolCell ()

@property (strong, nonatomic) UIView *infoContainerView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *resultsLabel;

@end

@implementation STKEventPoolCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor stk_backgroundColor];

        [self setupInfoContainerView];
        [self setupNameLabel];
        [self setupResultsLabel];
    }

    return self;
}

#pragma mark - Setup

- (void)setupInfoContainerView {
    self.infoContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.infoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.infoContainerView];

    self.infoContainerView.backgroundColor = [UIColor whiteColor];

    [self.infoContainerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:1.0f].active = YES;
    [self.infoContainerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.infoContainerView.trailingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.infoContainerView.bottomAnchor].active = YES;
}

- (void)setupNameLabel {
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoContainerView addSubview:self.nameLabel];

    self.nameLabel.numberOfLines = 0;

    [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.infoContainerView.leadingAnchor constant:12.5f].active = YES;
    [self.nameLabel.topAnchor constraintEqualToAnchor:self.infoContainerView.topAnchor constant:12.5f].active = YES;
    [self.infoContainerView.bottomAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:12.5f].active = YES;
}

- (void)setupResultsLabel {
    self.resultsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.resultsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoContainerView addSubview:self.resultsLabel];

    self.resultsLabel.numberOfLines = 0;
    [self.resultsLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.resultsLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [self.resultsLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    [self.resultsLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:12.5f].active = YES;
    [self.infoContainerView.trailingAnchor constraintEqualToAnchor:self.resultsLabel.trailingAnchor constant:12.5f].active = YES;
}

- (void)setupWithStanding:(STKEventStanding *)standing {
    NSString *name = standing.teamName ?: @"No name";
    NSDictionary *nameAttributes = [STKAttributes stk_postNodeTitleAttributes];
    self.nameLabel.attributedText = [[NSAttributedString alloc] initWithString:name attributes:nameAttributes];

    NSString *wins = standing.wins.stringValue ?: @"0";
    NSString *losses = standing.losses.stringValue ?: @"0";
    NSString *results = [NSString stringWithFormat:@"%@ - %@", wins, losses];
    NSDictionary *resultsAttributes = [STKAttributes stk_postNodeTitleAttributes];
    self.resultsLabel.attributedText = [[NSAttributedString alloc] initWithString:results attributes:resultsAttributes];
}

@end
