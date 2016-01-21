//
//  STKListBackgroundDefaultContentView.h
//  Stack
//
//  Created by Bradley Smith on 12/25/15.
//  Copyright © 2015 Brad Smith. All rights reserved.
//

@import UIKit;

#import "STKListBackgroundView.h"

@interface STKListBackgroundDefaultContentView : UIView <STKListBackgroundContentViewProtocol>

- (UIImage *)imageForState:(STKListBackgroundViewState)state;
- (NSString *)titleForState:(STKListBackgroundViewState)state;
- (NSString *)messageForState:(STKListBackgroundViewState)state;

- (void)setImage:(UIImage *)image forState:(STKListBackgroundViewState)state;
- (void)setTitle:(NSString *)title forState:(STKListBackgroundViewState)state;
- (void)setMessage:(NSString *)message forState:(STKListBackgroundViewState)state;

@end
