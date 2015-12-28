//
//  STKSettingsItem.h
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, STKSettingsItemType) {
    STKSettingsItemTypeDisclosureIndicator,
    STKSettingsItemTypeSwitch
};

@interface STKSettingsItem : NSObject

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(UIImage *)image
                       target:(id)target
                       action:(SEL)action
                         type:(STKSettingsItemType)type;

- (void)performAction;
- (void)performActionWithValue:(id)value;

@property (strong, nonatomic, readonly) UIImage *image;

@property (copy, nonatomic, readonly) NSString *title;

@property (assign, nonatomic, readonly) STKSettingsItemType type;
@property (assign, nonatomic) BOOL value;
@property (assign, nonatomic) BOOL enabled;

@end
