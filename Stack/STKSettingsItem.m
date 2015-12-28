//
//  STKSettingsItem.m
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import "STKSettingsItem.h"

@interface STKSettingsItem ()

@property (strong, nonatomic, readwrite) UIImage *image;

@property (copy, nonatomic, readwrite) NSString *title;

@property (weak, nonatomic) id target;

@property (assign, nonatomic) SEL action;
@property (assign, nonatomic, readwrite) STKSettingsItemType type;

@end

@implementation STKSettingsItem

#pragma mark - Lifecycle

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                       target:(id)target
                       action:(SEL)action
                         type:(STKSettingsItemType)type {
    STKSettingsItem *item = [[STKSettingsItem alloc] init];
    item.title = title;
    item.image = image;
    item.target = target;
    item.action = action;
    item.type = type;
    item.enabled = YES;

    return item;
}

#pragma mark - Actions

- (void)performAction {
    [self performActionWithValue:nil];
}

- (void)performActionWithValue:(id)value {
    if (self.target && self.action) {
        if ([self.target respondsToSelector:self.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self withObject:value];
#pragma clang diagnostic pop
        }
    }
}

@end
