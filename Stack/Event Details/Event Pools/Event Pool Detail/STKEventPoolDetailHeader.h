//
//  STKEventPoolDetailHeader.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STKEventPoolDetailHeader : UITableViewHeaderFooterView

+ (CGFloat)height;
- (void)setupWithDate:(NSDate *)date;

@end
