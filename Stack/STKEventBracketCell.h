//
//  STKEventBracketCell.h
//  Stack
//
//  Created by Bradley Smith on 2/7/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STKEventGame;

@interface STKEventBracketCell : UICollectionViewCell

+ (CGFloat)height;
- (void)setupWithGame:(STKEventGame *)game;

@end
