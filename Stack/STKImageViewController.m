//
//  STKImageViewController.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKImageViewController.h"

#import "STKImageCache.h"
#import "STKImageDownloader.h"

#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <pop/POP.h>
#import <tgmath.h>

static CGFloat const kSTKImageViewControllerMinimumZoom = 1.0f;
static CGFloat const kSTKImageViewControllerMaximumZoom = 2.0f;

@interface STKImageViewController () <UIScrollViewDelegate, POPAnimationDelegate>

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) ASNetworkImageNode *networkImageNode;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (copy, nonatomic) NSURL *URL;

@property (assign, nonatomic) NSInteger presentAnimationCompletionCount;
@property (assign, nonatomic) NSInteger dismissAnimationCompletionCount;
@property (assign, nonatomic) CGPoint previousLocation;
@property (assign, nonatomic) CGRect originalRect;

@end

@implementation STKImageViewController

- (BOOL)prefersStatusBarHidden {
    return self.presentingViewController.prefersStatusBarHidden;
}

#pragma mark - Lifecycle

- (instancetype)initWithURL:(NSURL *)URL originalRect:(CGRect)originalRect {
    self = [super init];

    if (self) {
        self.URL = URL;
        self.originalRect = originalRect;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor clearColor];

    [self setupBackgroundView];
    [self setupScrollView];
    [self setupNetworkImageNode];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.scrollView addGestureRecognizer:self.panGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDismiss)];
    [self.view addGestureRecognizer:tapGesture];

    self.backgroundView.alpha = 0.0f;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (CGRectEqualToRect(self.scrollView.frame, CGRectZero)) {
        self.backgroundView.frame = self.view.frame;
        self.scrollView.frame = self.view.frame;

        self.networkImageNode.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.originalRect), CGRectGetHeight(self.originalRect));
        self.scrollView.contentSize = self.networkImageNode.frame.size;

        [self centerScrollViewContents];

        self.scrollView.center = CGPointMake(CGRectGetMidX(self.originalRect), CGRectGetMidY(self.originalRect));
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([self.delegate respondsToSelector:@selector(imageViewControllerWillStartPresentAnimation:)]) {
        [self.delegate imageViewControllerWillStartPresentAnimation:self];
    }

    [self performPresentAnimation];
}

#pragma mark - Setup

- (void)setupBackgroundView {
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.backgroundView];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = kSTKImageViewControllerMinimumZoom;
    self.scrollView.maximumZoomScale = kSTKImageViewControllerMaximumZoom;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = YES;

    [self.view addSubview:self.scrollView];
}

- (void)setupNetworkImageNode {
    self.networkImageNode = [[ASNetworkImageNode alloc] initWithCache:[STKImageCache sharedInstance] downloader:[STKImageDownloader sharedInstance]];
    self.networkImageNode.contentMode = UIViewContentModeScaleAspectFill;
    self.networkImageNode.displaysAsynchronously = NO;

    UIImage *image = [[STKImageCache sharedInstance] imageForURL:self.URL];
    if (image) {
        self.networkImageNode.image = image;
    }
    else {
        self.networkImageNode.URL = self.URL;
    }

    [self.scrollView addSubnode:self.networkImageNode];
}

#pragma mark - Actions

- (void)didTapDismiss {
    [self performDismissAnimation];
}

- (void)centerScrollViewContents {
    CGFloat horizontalInset = 0.0f;
    CGFloat verticalInset = 0.0f;

    if (self.scrollView.contentSize.width < CGRectGetWidth(self.scrollView.bounds)) {
        horizontalInset = (CGRectGetWidth(self.scrollView.bounds) - self.scrollView.contentSize.width) * 0.5f;
    }

    if (self.scrollView.contentSize.height < CGRectGetHeight(self.scrollView.bounds)) {
        verticalInset = (CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentSize.height) * 0.5f;
    }

    if (self.scrollView.window.screen.scale < 2.0f) {
        horizontalInset = __tg_floor(horizontalInset);
        verticalInset = __tg_floor(verticalInset);
    }

    // Use `contentInset` to center the contents in the scroll view. Reasoning explained here: http://petersteinberger.com/blog/2013/how-to-center-uiscrollview/
    self.scrollView.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self.view];
    CGFloat deltaX = location.x - self.previousLocation.x;
    CGFloat deltaY = location.y - self.previousLocation.y;

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {

        }
            break;

        case UIGestureRecognizerStateChanged: {
            CGPoint center = self.scrollView.center;
            center.x += deltaX;
            center.y += deltaY;
            self.scrollView.center = center;

            CGFloat viewCenterY = self.view.center.y;
            CGFloat delta = __tg_fabs(center.y - viewCenterY);
            CGFloat percent = MIN(delta / CGRectGetMidY(self.view.frame), 100.0f);

            self.backgroundView.alpha = 1.0f - percent;
        }
            break;

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            CGPoint velocity = [gesture velocityInView:gesture.view];
            if (__tg_fabs(velocity.x) > 150.0f || __tg_fabs(velocity.y) > 150.0f) {
                [self performDismissAnimationWithVelocity:velocity];
            }
            else {
                [self performPresentAnimation];
            }
        }
            break;

        default:
            break;
    }

    self.previousLocation = location;
}

- (void)performPresentAnimation {
    self.view.userInteractionEnabled = NO;

    POPSpringAnimation *translationAnimation = [self.scrollView pop_animationForKey:@"translation"];
    if (!translationAnimation) {
        translationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    }

    CGPoint center = self.view.center;
    translationAnimation.toValue = [NSValue valueWithCGPoint:center];
    translationAnimation.name = @"present_translation";
    translationAnimation.delegate = self;

    [self.scrollView pop_addAnimation:translationAnimation forKey:@"translation"];

    POPSpringAnimation *alphaAnimation = [self.backgroundView pop_animationForKey:@"alpha"];
    if (!alphaAnimation) {
        alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    }

    alphaAnimation.name = @"present_alpha";
    alphaAnimation.delegate = self;
    alphaAnimation.toValue = @(1.0f);

    [self.backgroundView pop_addAnimation:alphaAnimation forKey:@"alpha"];
}

- (void)performDismissAnimation {
    [self performDismissAnimationWithVelocity:CGPointZero];
}

- (void)performDismissAnimationWithVelocity:(CGPoint)velocity {
    self.view.userInteractionEnabled = NO;

    POPSpringAnimation *translationAnimation = [self.scrollView pop_animationForKey:@"translation"];
    if (!translationAnimation) {
        translationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    }

    CGPoint center = CGPointMake(CGRectGetMidX(self.originalRect), CGRectGetMidY(self.originalRect));
    translationAnimation.toValue = [NSValue valueWithCGPoint:center];
    translationAnimation.name = @"dismiss_translation";
    translationAnimation.delegate = self;
    translationAnimation.velocity = [NSValue valueWithCGPoint:velocity];

    [self.scrollView pop_addAnimation:translationAnimation forKey:@"translation"];

    POPSpringAnimation *alphaAnimation = [self.backgroundView pop_animationForKey:@"alpha"];
    if (!alphaAnimation) {
        alphaAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    }

    alphaAnimation.name = @"dismiss_alpha";
    alphaAnimation.delegate = self;
    alphaAnimation.toValue = @(0.0f);

    [self.backgroundView pop_addAnimation:alphaAnimation forKey:@"alpha"];
}

#pragma mark - Scroll View Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.networkImageNode.view;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];

    self.panGesture.enabled = (scrollView.zoomScale == kSTKImageViewControllerMinimumZoom);
}

#pragma mark - POP Animation Delegate

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if ([anim.name containsString:@"dismiss"]) {
        self.dismissAnimationCompletionCount++;

        if (self.dismissAnimationCompletionCount == 2) {
            if ([self.delegate respondsToSelector:@selector(imageViewControllerDidFinishDismissAnimation:)]) {
                [self.delegate imageViewControllerDidFinishDismissAnimation:self];
            }
        }
    }
    else if ([anim.name containsString:@"present"]) {
        self.presentAnimationCompletionCount++;
        
        if (self.presentAnimationCompletionCount == 2) {
            self.presentAnimationCompletionCount = 0;
            self.view.userInteractionEnabled = YES;
        }
    }
}

@end
