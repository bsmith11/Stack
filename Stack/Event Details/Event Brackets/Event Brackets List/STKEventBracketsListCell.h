//
//  STKEventBracketsListCell.h
//  Stack
//
//  Created by Bradley Smith on 2/8/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STKEventBracket;

@interface STKEventBracketsListCell : UITableViewCell

- (void)setupWithBracket:(STKEventBracket *)bracket;

@end
