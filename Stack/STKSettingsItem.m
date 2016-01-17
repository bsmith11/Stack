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
@property (strong, nonatomic) NSMutableDictionary *targets;
@property (strong, nonatomic) NSMutableDictionary *actions;

@property (copy, nonatomic, readwrite) NSString *title;

@property (assign, nonatomic, readwrite) STKSettingsItemType type;

@end

@implementation STKSettingsItem

#pragma mark - Lifecycle

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                         type:(STKSettingsItemType)type {
    STKSettingsItem *item = [[STKSettingsItem alloc] init];
    item.title = title;
    item.image = image;
    item.type = type;
    item.enabled = YES;

    item.targets = [NSMutableDictionary dictionary];
    item.actions = [NSMutableDictionary dictionary];

    return item;
}

- (void)addTarget:(id)target action:(SEL)action forEvent:(STKSettingsItemEvent)event {
    if (target && action) {
        [self.targets setObject:target forKey:@(event)];
        [self.actions setObject:NSStringFromSelector(action) forKey:@(event)];
    }
    else {
        [self.targets removeObjectForKey:@(event)];
        [self.actions removeObjectForKey:@(event)];
    }
}

- (void)performActionForEvent:(STKSettingsItemEvent)event {
    id target = [self.targets objectForKey:@(event)];
    NSString *actionString = [self.actions objectForKey:@(event)];

    if (target && actionString) {
        SEL action = NSSelectorFromString(actionString);

        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:action withObject:self];
#pragma clang diagnostic pop
        }
    }
}

@end
