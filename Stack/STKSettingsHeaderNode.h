//
//  STKSettingsHeaderNode.h
//  Stack
//
//  Created by Bradley Smith on 12/28/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class STKSettingsHeader;

@interface STKSettingsHeaderNode : ASCellNode

- (void)setupWithSettingsHeader:(STKSettingsHeader *)header;

@end
