//
//  STKEventCell.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventCell.h"

#import "STKEvent.h"
#import "STKEventGroup.h"

#import "STKAttributes.h"
#import "UIColor+STKStyle.h"

#import <tgmath.h>

@interface STKEventCell ()

@property (strong, nonatomic) UIView *infoContainerView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *locationLabel;

@end

@implementation STKEventCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor stk_backgroundColor];

        [self setupInfoContainerView];
        [self setupNameLabel];
        [self setupLocationLabel];
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
    [self.infoContainerView.trailingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:12.5f].active = YES;
}

- (void)setupLocationLabel {
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoContainerView addSubview:self.locationLabel];

    self.locationLabel.numberOfLines = 0;

    [self.locationLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:6.25f].active = YES;
    [self.locationLabel.leadingAnchor constraintEqualToAnchor:self.infoContainerView.leadingAnchor constant:12.5f].active = YES;
    [self.infoContainerView.bottomAnchor constraintEqualToAnchor:self.locationLabel.bottomAnchor constant:12.5f].active = YES;
    [self.infoContainerView.trailingAnchor constraintEqualToAnchor:self.locationLabel.trailingAnchor constant:12.5f].active = YES;
}

- (void)setupWithEvent:(STKEvent *)event {
    NSString *name = event.name ?: @"No name";
    NSDictionary *nameAttributes = [STKAttributes stk_postNodeTitleAttributes];
    self.nameLabel.attributedText = [[NSAttributedString alloc] initWithString:name attributes:nameAttributes];

    NSString *city = event.city;
    NSString *state = event.state;
    NSMutableString *location = [NSMutableString string];

    if ([state isEqualToString:@"UM"]) {
        [location appendString:@"TBD"];
    }
    else {
        if (city.length > 0) {
            [location appendString:city];
        }

        if (location.length > 0) {
            [location appendString:@", "];
        }

        if (state.length > 0) {
            [location appendString:state];
        }
    }

    NSDictionary *locationAttributes = [STKAttributes stk_postNodeDateAttributes];
    self.locationLabel.attributedText = [[NSAttributedString alloc] initWithString:location attributes:locationAttributes];
}

#pragma mark - Height

+ (CGFloat)heightWithEvent:(STKEvent *)event width:(CGFloat)width {
    CGSize size = CGSizeMake(width - (2 * 12.5f), CGFLOAT_MAX);
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;

    NSString *name = event.name ?: @"No name";
    NSDictionary *nameAttributes = [STKAttributes stk_postNodeTitleAttributes];
    NSAttributedString *nameAttributedString = [[NSAttributedString alloc] initWithString:name attributes:nameAttributes];
    CGRect nameBoundingRect = [nameAttributedString boundingRectWithSize:size options:options context:nil];
    CGFloat nameHeight = __tg_ceil(CGRectGetHeight(nameBoundingRect));

    NSString *city = event.city;
    NSString *state = event.state;
    NSMutableString *location = [NSMutableString string];

    if ([state isEqualToString:@"UM"]) {
        [location appendString:@"TBD"];
    }
    else {
        if (city.length > 0) {
            [location appendString:city];
        }

        if (location.length > 0) {
            [location appendString:@", "];
        }

        if (state.length > 0) {
            [location appendString:state];
        }
    }

    NSDictionary *locationAttributes = [STKAttributes stk_postNodeDateAttributes];
    NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:location attributes:locationAttributes];
    CGRect locationBoundingRect = [locationAttributedString boundingRectWithSize:size options:options context:nil];
    CGFloat locationHeight = __tg_ceil(CGRectGetHeight(locationBoundingRect));

    return 1.0f + 12.5f + nameHeight + 6.25f + locationHeight + 12.5f;
}

@end
