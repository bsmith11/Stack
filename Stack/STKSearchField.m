//
//  STKSearchField.m
//  Stack
//
//  Created by Bradley Smith on 12/27/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSearchField.h"

#import "UIFont+STKStyle.h"
#import "UIColor+STKStyle.h"
#import "STKAttributes.h"

static const CGFloat kSTKHorizontalInset = 7.0f;
static const CGFloat kSTKVerticalInset = 1.0f;
static const CGFloat kSTKHeight = 30.0f;

@interface STKSearchField ()

- (void)stk_editingChanged:(id)sender;
- (void)setupSearchImageView;
- (void)setupSpinner;
- (void)setupClearButton;

@property (strong, nonatomic) UIImageView *searchImageView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIButton *clearButton;

@end

@implementation STKSearchField

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.font = [UIFont stk_searchTextFieldFont];
        self.backgroundColor = [UIColor stk_searchTextFieldColor];
        self.textColor = [UIColor stk_stackColor];
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.tintColor = [UIColor stk_stackColor];

        [self addTarget:self action:@selector(stk_editingChanged:) forControlEvents:UIControlEventEditingChanged];

        [self setupSearchImageView];
        [self setupSpinner];
        [self setupClearButton];

        self.leftView = self.searchImageView;
        self.leftViewMode = UITextFieldViewModeAlways;

        self.rightView = self.clearButton;
        self.rightViewMode = UITextFieldViewModeNever;
    }

    return self;
}

#pragma mark - Setup

- (void)setupSearchImageView {
    UIImage *image = [[UIImage imageNamed:@"Text Field Search Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.searchImageView = [[UIImageView alloc] initWithImage:image];
    self.searchImageView.contentMode = UIViewContentModeCenter;
    self.searchImageView.tintColor = [UIColor stk_stackColor];

    [self.searchImageView sizeToFit];
}

- (void)setupSpinner {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.color = [UIColor stk_stackColor];
    self.spinner.hidesWhenStopped = YES;

    CGFloat scale = self.searchImageView.image.size.width / CGRectGetWidth(self.spinner.frame);
    self.spinner.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)setupClearButton {
    UIImage *image = [[UIImage imageNamed:@"Text Field Clear Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.imageView.tintColor = [UIColor stk_stackColor];
    [self.clearButton setImage:image forState:UIControlStateNormal];
    [self.clearButton addTarget:self
                         action:@selector(stk_clearButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];

    [self.clearButton sizeToFit];
}

#pragma mark - Overrides

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect = CGRectOffset(rect, kSTKHorizontalInset, 0.0f);

    return rect;
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect rect = [super rightViewRectForBounds:bounds];
    rect = CGRectOffset(rect, -kSTKHorizontalInset, 0.0f);

    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self stk_placeholderAndTextRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self stk_placeholderAndTextRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self stk_placeholderAndTextRectForBounds:bounds];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, kSTKHeight);
}

#pragma mark - Actions

- (CGRect)stk_placeholderAndTextRectForBounds:(CGRect)bounds {
    CGRect newRect = CGRectMake(CGRectGetMinX(bounds) + CGRectGetMaxX(self.leftView.frame) + kSTKHorizontalInset,
                                CGRectGetMinY(bounds) + kSTKVerticalInset,
                                CGRectGetWidth(bounds) - CGRectGetWidth(self.leftView.frame) - CGRectGetWidth(self.rightView.frame) - (kSTKHorizontalInset * 3),
                                CGRectGetHeight(bounds));
    return newRect;
}

- (void)stk_editingChanged:(id)sender {
    self.rightViewMode = (self.text.length > 0) ? UITextFieldViewModeWhileEditing : UITextFieldViewModeNever;
}

- (void)stk_clearButtonTapped:(id)sender {
    self.text = nil;
    self.rightViewMode = UITextFieldViewModeNever;

    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (void)stk_setPlaceholderText:(NSString *)placeholderText {
    placeholderText = placeholderText ?: @"";

    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:[STKAttributes stk_searchTextFieldPlaceholderAttributes]];
}

- (void)stk_clearText {
    [self stk_clearButtonTapped:self];
}

#pragma mark - Setters

- (void)setWidth:(CGFloat)width {
    if (_width != width) {
        _width = width;

        CGRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
    }
}

- (void)setLoading:(BOOL)loading {
    if (_loading != loading) {
        _loading = loading;

        if (loading) {
            [self.spinner startAnimating];
            self.leftView = self.spinner;
        }
        else {
            [self.spinner stopAnimating];
            self.leftView = self.searchImageView;
        }
    }
}

@end
