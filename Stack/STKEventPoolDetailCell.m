//
//  STKEventPoolDetailCell.m
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventPoolDetailCell.h"

#import "STKEventGame.h"

#import "STKAttributes.h"
#import "UIFont+STKStyle.h"
#import "UIColor+STKStyle.h"

@interface STKEventPoolDetailCell ()

@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIStackView *contentStackView;
@property (strong, nonatomic) UIStackView *teamsStackView;
@property (strong, nonatomic) UIStackView *homeStackView;
@property (strong, nonatomic) UIStackView *awayStackView;
@property (strong, nonatomic) UIStackView *infoStackView;

@property (strong, nonatomic) UILabel *homeTeamLabel;
@property (strong, nonatomic) UILabel *homeScoreLabel;
@property (strong, nonatomic) UILabel *awayTeamLabel;
@property (strong, nonatomic) UILabel *awayScoreLabel;
@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation STKEventPoolDetailCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self setupSeparatorView];
        [self setupContentStackView];
        [self setupTeamsStackView];
        [self setupHomeStackView];
        [self setupAwayStackView];
        [self setupInfoStackView];
    }

    return self;
}

#pragma mark - Setup

- (void)setupSeparatorView {
    self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.separatorView];

    self.separatorView.backgroundColor = [UIColor stk_backgroundColor];

    [self.separatorView.heightAnchor constraintEqualToConstant:1.0f].active = YES;
    [self.separatorView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.separatorView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.separatorView.trailingAnchor].active = YES;
}

- (void)setupContentStackView {
    self.contentStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.contentStackView];

    self.contentStackView.axis = UILayoutConstraintAxisVertical;
    self.contentStackView.spacing = 12.5f;

    [self.contentStackView.topAnchor constraintEqualToAnchor:self.separatorView.bottomAnchor constant:12.5f].active = YES;
    [self.contentStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12.5f].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.contentStackView.trailingAnchor constant:12.5f].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.contentStackView.bottomAnchor constant:12.5f].active = YES;
}

- (void)setupTeamsStackView {
    self.teamsStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.teamsStackView.axis = UILayoutConstraintAxisVertical;
    self.teamsStackView.spacing = 6.25f;
    [self.contentStackView addArrangedSubview:self.teamsStackView];
}

- (void)setupHomeStackView {
    self.homeStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.homeStackView.axis = UILayoutConstraintAxisHorizontal;
    [self.teamsStackView addArrangedSubview:self.homeStackView];

    self.homeTeamLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.homeTeamLabel.numberOfLines = 1;
    [self.homeStackView addArrangedSubview:self.homeTeamLabel];

    self.homeScoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.homeScoreLabel.numberOfLines = 1;
    [self.homeScoreLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.homeScoreLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.homeStackView addArrangedSubview:self.homeScoreLabel];
}

- (void)setupAwayStackView {
    self.awayStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.awayStackView.axis = UILayoutConstraintAxisHorizontal;
    [self.teamsStackView addArrangedSubview:self.awayStackView];

    self.awayTeamLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.awayTeamLabel.numberOfLines = 1;
    [self.awayStackView addArrangedSubview:self.awayTeamLabel];

    self.awayScoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.awayScoreLabel.numberOfLines = 1;
    [self.awayScoreLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.awayScoreLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.awayStackView addArrangedSubview:self.awayScoreLabel];
}

- (void)setupInfoStackView {
    self.infoStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.infoStackView.axis = UILayoutConstraintAxisHorizontal;
    [self.contentStackView addArrangedSubview:self.infoStackView];

    self.fieldLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fieldLabel.numberOfLines = 1;
    [self.infoStackView addArrangedSubview:self.fieldLabel];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.numberOfLines = 1;
    [self.statusLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.statusLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoStackView addArrangedSubview:self.statusLabel];
}

- (void)setupWithGame:(STKEventGame *)game {
    NSDictionary *homeAttributes = [STKAttributes stk_postNodeTitleAttributes];
    NSDictionary *awayAttributes = [STKAttributes stk_postNodeTitleAttributes];
    NSDictionary *winnerAttributes = [STKAttributes stk_eventsGameWinnerAttributes];

    NSString *homeTeam = game.homeTeamName ?: @"No Name";
    NSString *homeScore = game.homeTeamScore ?: @"";
    NSString *awayTeam = game.awayTeamName ?: @"No Name";
    NSString *awayScore = game.awayTeamScore ?: @"";

    if ([game.status isEqualToString:@"Final"]) {
        if (homeScore.integerValue > awayScore.integerValue) {
            homeAttributes = winnerAttributes;
        }
        else if (awayScore.integerValue > homeScore.integerValue) {
            awayAttributes = winnerAttributes;
        }
    }

    self.homeTeamLabel.attributedText = [[NSAttributedString alloc] initWithString:homeTeam attributes:homeAttributes];
    self.homeScoreLabel.attributedText = [[NSAttributedString alloc] initWithString:homeScore attributes:homeAttributes];
    self.awayTeamLabel.attributedText = [[NSAttributedString alloc] initWithString:awayTeam attributes:awayAttributes];
    self.awayScoreLabel.attributedText = [[NSAttributedString alloc] initWithString:awayScore attributes:awayAttributes];

    NSDictionary *infoAttributes = [STKAttributes stk_postNodeDateAttributes];

    NSString *field = game.fieldName ?: @"TBD";
    NSString *status = game.status ?: @"";

    self.fieldLabel.attributedText = [[NSAttributedString alloc] initWithString:field attributes:infoAttributes];
    self.statusLabel.attributedText = [[NSAttributedString alloc] initWithString:status attributes:infoAttributes];
}

@end
