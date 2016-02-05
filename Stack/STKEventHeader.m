//
//  STKEventHeader.m
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import "STKEventHeader.h"

#import "STKAttributes.h"
#import "STKFormatter.h"
#import "UIFont+STKStyle.h"
#import "UIColor+STKStyle.h"

@interface STKEventHeader ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation STKEventHeader

#pragma mark - Lifecycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        self.contentView.backgroundColor = [UIColor stk_backgroundColor];

        [self setupTitleLabel];
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
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:12.5f].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:12.5f].active = YES;
}

- (void)setupWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *string = [dateFormatter stringFromDate:date];
    NSDictionary *attributes = [STKAttributes stk_settingsHeaderTitleAttributes];

    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

#pragma mark - Height

+ (CGFloat)height {
    CGFloat titleHeight = [UIFont stk_settingsHeaderTitleFont].lineHeight;
    CGFloat height = 12.5f + titleHeight + 12.5f;

    return height;
}

@end
