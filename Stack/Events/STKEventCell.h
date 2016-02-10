//
//  STKEventCell.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKEvent;

@interface STKEventCell : UITableViewCell

+ (CGFloat)heightWithEvent:(STKEvent *)event width:(CGFloat)width;

- (void)setupWithEvent:(STKEvent *)event;

@end
