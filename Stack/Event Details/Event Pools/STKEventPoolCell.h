//
//  STKEventPoolCell.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

@import UIKit;

@class STKEventStanding;

@interface STKEventPoolCell : UITableViewCell

- (void)setupWithStanding:(STKEventStanding *)standing;

@end
