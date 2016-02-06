//
//  STKEventPoolHeader.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKEventPool;

@protocol STKEventPoolHeaderDelegate <NSObject>

- (void)didSelectHeaderInSection:(NSInteger)section;

@end

@interface STKEventPoolHeader : UITableViewHeaderFooterView

+ (CGFloat)height;
- (void)setupWithPool:(STKEventPool *)pool section:(NSInteger)section;

@property (weak, nonatomic) id <STKEventPoolHeaderDelegate> delegate;

@end
