//
//  STKEventBracketCell.m
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventBracketCell.h"

#import "STKEventGame.h"

#import "STKFormatter.h"
#import "STKAttributes.h"
#import "UIFont+STKStyle.h"
#import "UIColor+STKStyle.h"

@interface STKEventBracketCell ()

@property (strong, nonatomic) UIStackView *contentStackView;
@property (strong, nonatomic) UIStackView *teamsStackView;
@property (strong, nonatomic) UIStackView *homeStackView;
@property (strong, nonatomic) UIStackView *awayStackView;
@property (strong, nonatomic) UIStackView *infoStackView;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *homeTeamLabel;
@property (strong, nonatomic) UILabel *homeScoreLabel;
@property (strong, nonatomic) UILabel *awayTeamLabel;
@property (strong, nonatomic) UILabel *awayScoreLabel;
@property (strong, nonatomic) UILabel *fieldLabel;
@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation STKEventBracketCell

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self setupContentStackView];
        [self setupDateLabel];
        [self setupTeamsStackView];
        [self setupHomeStackView];
        [self setupAwayStackView];
        [self setupInfoStackView];
    }

    return self;
}

#pragma mark - Setup

- (void)setupContentStackView {
    self.contentStackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.contentStackView];

    self.contentStackView.axis = UILayoutConstraintAxisVertical;
    self.contentStackView.spacing = 12.5f;

    [self.contentStackView.topAnchor constraintEqualToAnchor:self.self.contentView.topAnchor constant:12.5f].active = YES;
    [self.contentStackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12.5f].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.contentStackView.trailingAnchor constant:12.5f].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.contentStackView.bottomAnchor constant:12.5f].active = YES;
}

- (void)setupDateLabel {
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dateLabel.numberOfLines = 1;
    [self.contentStackView addArrangedSubview:self.dateLabel];
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
    NSDictionary *dateAttributes = [STKAttributes stk_postNodeDateAttributes];
    NSString *date = [[STKFormatter gameDisplayDateFormatter] stringFromDate:game.startDateFull] ?: @"No Date";

    self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:date attributes:dateAttributes];

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

    NSMutableDictionary *infoAttributes = [[STKAttributes stk_postNodeDateAttributes] mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    infoAttributes[NSParagraphStyleAttributeName] = paragraphStyle;

    NSString *field = game.fieldName ?: @"TBD";
    NSString *status = game.status ?: @"";

    self.fieldLabel.attributedText = [[NSAttributedString alloc] initWithString:field attributes:infoAttributes];
    self.statusLabel.attributedText = [[NSAttributedString alloc] initWithString:status attributes:infoAttributes];
}

#pragma mark - Height

+ (CGFloat)height {
    CGFloat subtextLineHeight = [UIFont stk_postNodeDateFont].lineHeight;
    CGFloat textLineHeight = [UIFont stk_postNodeTitleFont].lineHeight;

    return 12.5f + subtextLineHeight + 12.5f + textLineHeight + 6.25f + textLineHeight + 12.5f + subtextLineHeight + 12.5f;
}

@end
