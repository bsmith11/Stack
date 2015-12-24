//
//  STKWebNode.m
//  Stack
//
//  Created by Bradley Smith on 12/22/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import WebKit;

#import "STKWebNode.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKWebNode ()

@property (strong, nonatomic) NSURLRequest *request;

@end

@implementation STKWebNode

+ (Class)viewClass {
    return [WKWebView class];
}

- (instancetype)init {
    self = [super initWithViewBlock:^UIView *{
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.requiresUserActionForMediaPlayback = YES;
        return [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    }];

    if (self) {

    }

    return self;
}

- (WKWebView *)webView {
    WKWebView *webView = nil;

    if (self.nodeLoaded) {
        webView = (WKWebView *)self.view;
    }

    return webView;
}

- (void)didLoad {
    [super didLoad];

    self.webView.scrollView.scrollEnabled = NO;

    if (self.request) {
        [self.webView loadRequest:self.request];
        self.request = nil;
    }
}

- (void)loadRequest:(NSURLRequest *)request {
    if (self.nodeLoaded) {
        [self.webView loadRequest:request];

        self.request = nil;
    }
    else {
        self.request = request;
    }
}

@end
