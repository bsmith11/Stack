//
//  STKSettingsItemNode.h
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKSettingsItem, STKSettingsItemNode;

@protocol STKSettingsItemNodeDelegate <NSObject>

@required
- (void)settingsItemNode:(STKSettingsItemNode *)node didChangeValue:(BOOL)value;

@end

@interface STKSettingsItemNode : ASCellNode

- (void)setupWithSettingsItem:(STKSettingsItem *)item;

@property (weak, nonatomic) id <STKSettingsItemNodeDelegate> delegate;

@end
