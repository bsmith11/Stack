//
//  STKSettingsHeaderNode.h
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKSettingsHeader, STKSettingsHeaderNode;

@protocol STKSettingsHeaderNodeDelegate <NSObject>

@required
- (void)settingsHeaderNode:(STKSettingsHeaderNode *)node didTapLink:(NSURL *)link;

@end

@interface STKSettingsHeaderNode : ASCellNode

- (void)setupWithSettingsHeader:(STKSettingsHeader *)header delegate:(id <STKSettingsHeaderNodeDelegate>)delegate;

@property (weak, nonatomic) id <STKSettingsHeaderNodeDelegate> delegate;

@end
