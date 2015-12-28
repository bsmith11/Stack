//
//  STKSwitchNode.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSwitchNode.h"

#import "UIColor+STKStyle.h"

#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>

@interface STKSwitchNode ()

@property (strong, nonatomic) UISwitch *switchView;

@property (copy, nonatomic) NSString *actionString;

@property (weak, nonatomic) id target;

@end


@implementation STKSwitchNode

+ (Class)viewClass {
    return [UISwitch class];
}

- (UISwitch *)switchView {
    UISwitch *switchView = nil;

    if (self.nodeLoaded) {
        switchView = (UISwitch *)self.view;
    }

    return switchView;
}

- (void)didLoad {
    [super didLoad];

    self.switchView.on = self.on;
    self.switchView.onTintColor = [UIColor stk_stackColor];
    [self.switchView addTarget:self action:@selector(switchViewDidChangeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchViewDidChangeValue:(UISwitch *)switchView {
    self.on = switchView.on;

    if (self.target && self.actionString) {
        SEL action = NSSelectorFromString(self.actionString);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:action withObject:self];
#pragma clang diagnostic pop
    }
}

- (void)addTarget:(id)target action:(SEL)action {
    NSParameterAssert(action);

    self.target = target;
    self.actionString = NSStringFromSelector(action);
}

- (void)setOn:(BOOL)on {
    if (_on != on) {
        _on = on;

        self.switchView.on = on;
    }
}

@end
