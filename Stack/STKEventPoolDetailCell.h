//
//  STKEventPoolDetailCell.h
//  Stack
//
//  Created by Bradley Smith on 2/5/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STKEventGame;

@interface STKEventPoolDetailCell : UITableViewCell

- (void)setupWithGame:(STKEventGame *)game;

@end
