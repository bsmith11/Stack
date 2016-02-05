//
//  STKEventHeader.h
//  Stack
//
//  Created by Bradley Smith on 2/3/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import UIKit;

@interface STKEventHeader : UITableViewHeaderFooterView

+ (CGFloat)height;

- (void)setupWithDate:(NSDate *)date;

@end
